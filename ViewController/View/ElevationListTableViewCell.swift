import UIKit
import SwipeCellKit

class ElevationListTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    var task: RealmData? {
        didSet {
            if let t = task {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "ja_JP")
                dateLabel.text = formatter.string(from: t.date)
                bodyLabel.text = String(format: "%.2fm", t.elevation)
                memoLabel.text = t.memo 
            } else {
                return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
