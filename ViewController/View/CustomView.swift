import UIKit
import MapKit

protocol CustomViewDelegate: class {
    func startButtonAction()
    
    func finishButtonAction()
    
//    func stopButtonAction()
    
    func restartButtonAction()

}

class CustomView: UIView {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var elevationLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var stackButton: UIStackView!
    
    var elevation = "0.0m"
    {
        didSet {
            elevationLabel.text = elevation
        }
    }
    
    weak var delegate: CustomViewDelegate?
    
    class func instance() -> CustomView {
        return UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CustomView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        restartButton.layer.cornerRadius = 45
        finishButton.layer.cornerRadius = 45

        stackButton.isHidden = true
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        delegate?.startButtonAction()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        delegate?.restartButtonAction()
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
//        startButton.isHidden = false
//        stackButton.isHidden = true
        delegate?.finishButtonAction()
        
//        elevation = "0.0m"
    }
    
    func setUpLocationAlert () -> UIAlertController {
        let alertTitle = "位置情報取得が許可されていません"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        
        alert.addAction(defaultAction)
        
        return alert
    }
    
    func setUpFinishConfirmAlert() {
        let alert = UIAlertController(title: "アクティビティを完了", message: "このアクティビティを終了してもいいですか？", preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
    }
}

