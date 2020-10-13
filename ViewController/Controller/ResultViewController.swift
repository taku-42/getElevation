import UIKit
import UITextView_Placeholder

class ResultViewController: UIViewController {
    
    let mapViewController = MapViewController()
    
    let customModel = CustomModel()

    @IBOutlet weak var elevationLabel: UILabel!
    
    var elevationGain: Double? 
    
    @IBOutlet weak var memoTextField: UITextView!
    
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextField.placeholder = "メモ"
        
        let elevationString = String(format: "%.2fm", elevationGain ?? 0.0)
        elevationLabel.text = elevationString
    }
    
    @IBAction func trashBarButtonPressed(_ sender: Any) {
        setUpTrashAlert()
    }

    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        let memo = self.memoTextField.text
        self.customModel.setDataToSave(elevationGain: self.elevationGain, memo: memo)
        self.dismiss(animated: true)
    }
    
    func setUpTrashAlert() {
        let alert = UIAlertController(title: "アクティビティを削除します", message: "このアクティビティを削除してもいいですか？", preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            self.dismiss(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            return
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
            
    }
    
    //入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.memoTextField.isFirstResponder) {
            self.memoTextField.resignFirstResponder()
        }
    }
}

//extension ResultViewController: UITextViewDelegate {
    
