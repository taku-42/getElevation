import Foundation
import UIKit

@IBDesignable
class PositiveSimpleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customDesign()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        customDesign()
    }
    
    private func customDesign() {
        backgroundColor = UIColor(red: 92/255, green: 225/255, blue: 230/255, alpha: 1.0)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 15.0
        layer.shadowColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
    }
}
