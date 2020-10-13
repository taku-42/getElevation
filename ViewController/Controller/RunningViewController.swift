import UIKit

protocol RunningViewDelegate: class {
    func pauseButtonAction()
}

class RunningViewController: UIViewController {

    @IBOutlet weak var elevationLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    weak var delegate: RunningViewDelegate?
    
    var elevation = "0.0m"
    {
        didSet {
            elevationLabel.text = elevation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pauseButton.layer.cornerRadius = 45
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        delegate?.pauseButtonAction()
        dismiss(animated: true)
    }
    

}
