import Foundation
import RealmSwift

//realmに保存するときのデータ構造
class RealmData: Object {
    @objc dynamic var elevation: Double = 0.0
    @objc dynamic var date = Date()
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var memo: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
