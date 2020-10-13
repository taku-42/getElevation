import UIKit
import SwipeCellKit

class ElevationSumTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    
    var totalElevationText: Double? {
        didSet {
            if let s = totalElevationText {
                bodyLabel.text = String(format: "%.2fm", s)
            } else {
                return 
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
