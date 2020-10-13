import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var customView: CustomView!
    var customModel: CustomModel!
    let runnnigVC = RunningViewController()
  
    var mapView: MKMapView!
    
    var userLocation: CLLocationCoordinate2D?

    var locationManager: CLLocationManager!
    
    var recordBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customModel = CustomModel()
        
        setUpCustomView()
        
        setUpMapView()
        
        setUpRecordBarButtonItem()
        
        setupTrackingBarButtonItem()
        
        runnnigVC.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocationManager()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(MapViewController.onDidBecomeActive(_:)),
          name: UIApplication.didBecomeActiveNotification,
          object: nil
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //なぜかstackViewの表示非表示がうまく行かないからこのように記述する
//        if customView.startButton.isHidden == true {
            customView.stackButton.isHidden = !customView.startButton.isHidden
//        }
    }
    
    @objc func onDidBecomeActive(_ notification: Notification?) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setUpCustomView() {
        customView = CustomView.instance()
        customView.frame = self.view.frame
        self.view.addSubview(customView)
        customView.delegate = self
        
        mapView = customView.mapView
    }
    
    func setUpMapView() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)

        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //表示する地図の範囲を設定
        var region:MKCoordinateRegion = mapView.region

        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02

        //設定した範囲をセットする
        mapView.setRegion(region, animated: true)
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        //最も制度の高い位置情報を要求する設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //5メートル移動するごとに位置情報を取得する
        locationManager.distanceFilter = 5
        //バックグラウンドでも位置情報を取得できるようにする
        locationManager.allowsBackgroundLocationUpdates = true
        //自動で位置情報の取得を中断しないようにする
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func setUpRecordBarButtonItem() {
        recordBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(recordBarButtonPressed(_:)))

        self.navigationItem.rightBarButtonItem = recordBarButtonItem
    }
    
    func setupTrackingBarButtonItem() {
        let userTrackingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)

        self.navigationItem.leftBarButtonItem = userTrackingBarButton
    }
    
    //位置情報の取得に失敗したときに呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        print("error")
    }
    
    //位置情報の取得に成功したときに呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        customModel.getElevationGain(locations, completionHandler: { (elevationGainString) in
            //UIに関連する操作なので非同期でやる
            DispatchQueue.main.async {
                self.customView.elevation = elevationGainString ?? "取得できませんでした"
                self.runnnigVC.elevation = elevationGainString ?? "取得できませんでした"
            }
        }, errorHandler: { (error) in
            print(error?.localizedDescription ?? "エラー情報なし")
        })
    }
}


//MARK: - Button Action

extension MapViewController: CustomViewDelegate, RunningViewDelegate {

    func startButtonAction() {
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showLocationAlert()
        } else {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            runnnigVC.modalPresentationStyle = .fullScreen
            present(runnnigVC, animated: true)
        }
    }
    
    func showLocationAlert() {
        let alert = customView.setUpLocationAlert()
        
        present(alert, animated: true, completion: nil)
    }
    
    func pauseButtonAction() {
        locationManager.stopUpdatingLocation()
        customView.startButton.isHidden = true
        
    }
    
    func restartButtonAction() {
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        runnnigVC.modalPresentationStyle = .fullScreen
        present(runnnigVC, animated: true)
    }
    
    func finishButtonAction()  {
        setUpFinishConfirmAlert()
    }
    
    func setUpFinishConfirmAlert() {
        let alert = UIAlertController(title: "アクティビティを終了します", message: "このアクティビティを終了してもいいですか？", preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            self.locationManager.stopUpdatingLocation()
            
            let vc = ResultViewController()
            vc.elevationGain = self.customModel.elevationGain
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
            self.customModel = CustomModel()
            self.customView.elevationLabel.text = "0.0m"
        
            self.customView.startButton.isHidden = false

        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            return
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @objc func recordBarButtonPressed(_ sender: UIBarButtonItem) {
        let vc = RecordListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
