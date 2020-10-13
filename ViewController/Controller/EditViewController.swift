import UIKit

class EditViewController: UIViewController {
    
    let customModel = CustomModel()

    @IBOutlet weak var elevationLabel: UILabel!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var task: RealmData?
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let t = task {
            
            elevationLabel.text = String(format: "%.2fm", t.elevation)
            memoTextView.text = t.memo
            id = t.id
        } else {
            return
        }
        
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let i = id {
            customModel.updateData(i, memo: memoTextView.text)
        }
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.memoTextView.isFirstResponder) {
            self.memoTextView.resignFirstResponder()
        }
    }
    
}
