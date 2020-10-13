import UIKit
import SwipeCellKit

class RecordListViewController: UIViewController {
    
    let customModel = CustomModel()

    @IBOutlet weak var tableView: UITableView!
    
    var sortByElevationBarButton: UIBarButtonItem!
    
    var sortByDateBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customModel.getDataFromRealm()
        
        setUpTableViewCell()
        
        setupBarButton()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func setUpTableViewCell() {
        tableView.register(UINib(nibName: "ElevationListTableViewCell", bundle: nil), forCellReuseIdentifier: "ElevationListTableViewCell")
        tableView.register(UINib(nibName: "ElevationSumTableViewCell", bundle: nil), forCellReuseIdentifier: "ElevationSumTableViewCell")
    }
    
    func setupBarButton() {
        sortByElevationBarButton = UIBarButtonItem(title: "獲得標高順", style: .done, target: self, action: #selector(sortByElevationBarButtonPressed(_:)))

        sortByDateBarButton = UIBarButtonItem(title: "日付順", style: .done, target: self, action: #selector(sortByDateBarButtonPressed(_:)))

        self.navigationItem.rightBarButtonItem = sortByElevationBarButton
    }
    
    @objc func sortByElevationBarButtonPressed(_ sender: UIBarButtonItem) {
        customModel.getDataSortedByElevation()
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = sortByDateBarButton
    }
    
    @objc func sortByDateBarButtonPressed(_ sender: UIBarButtonItem) {
        customModel.getDataFromRealm()
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = sortByElevationBarButton
    }
}

//MARK: - TableView Methods

extension RecordListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return customModel.countNumberOfData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ElevationSumTableViewCell", for: indexPath) as! ElevationSumTableViewCell
            
            let totalElevation = customModel.calculateToatalElevation()
            
            cell.totalElevationText = totalElevation
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ElevationListTableViewCell", for: indexPath) as! ElevationListTableViewCell
            
            let task = customModel.indexData(indexPath.row)
            
            cell.task = task
            
            //SwipeTableViewCellを適用する
            cell.delegate = self
            
            return cell
        }
    }
}


//MARK: - SwipeTableViewCell Methods

extension RecordListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "削除") { action, indexPath in
            
            self.setupAlert(indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: "編集") { (action, indexPath) in
            
            let task = self.customModel.indexData(indexPath.row)
            
            let editViewController = EditViewController()
            editViewController.modalPresentationStyle = .fullScreen
            editViewController.task = task
            self.present(editViewController, animated: true)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        return [deleteAction, editAction]
    }
    
    func setupAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "記録を削除", message: "削除してもよろしいでしょうか？", preferredStyle: UIAlertController.Style.alert)

        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            print("Yes")
            self.customModel.deleteData(indexPath)
            self.loadView()
            self.viewDidLoad()
        })

        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
        })

        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

    }
}
