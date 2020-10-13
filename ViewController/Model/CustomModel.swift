import Foundation
import MapKit
import RealmSwift

class CustomModel {
    
    //最初の標高はノーカウントにするためにbeforeElevationは大きな値に設定する
    private var beforeElevation: Double = pow(10, 5)
    private var afterElevation: Double = 0.0
    var elevationGain: Double = 0.0
    
    let realm = try! Realm()
    
    var model: Results<RealmData>?
    
    func getElevationGain(_ Locations: [CLLocation], completionHandler: @escaping (String?) -> Void, errorHandler: @escaping (Error?) -> Void ) {
        
        guard let userCoordinate = Locations.first?.coordinate else {
            completionHandler(nil)
            return
        }
        
        let userLocation = CLLocationCoordinate2DMake(userCoordinate.latitude, userCoordinate.longitude)
        
        // 国土地理院のURL
        let baseUrl = "https://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?"
        
        print(userLocation.longitude.description, userLocation.latitude.description)
        let lonUrl = "&lon=" + userLocation.longitude.description
        let latUrl = "&lat=" + userLocation.latitude.description
        // アウトプット形式をJSONに設定する
        let outtypeUrl = "&outtype=JSON"
        // URLとクエリを連結
        let listUrl = baseUrl + lonUrl + latUrl + outtypeUrl
        // URLを生成する
        guard let url = URL(string: listUrl) else {
            completionHandler(nil)
            return
        }
  
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                errorHandler(error)
                return
            }
            guard let data = data else {
                completionHandler(nil)
                return
            }
            // JSONを取得する

            guard let json = try? JSONDecoder().decode(ElevationData.self, from: data) else {
                completionHandler(nil)
                return
            }
            // JSONから標高を取得する
            self.afterElevation = json.elevation 
            self.calculateElevationGain()
            let elevationGainString = String(format: "%.2fm", self.elevationGain)
            print(self.beforeElevation, self.afterElevation, self.elevationGain)
            self.beforeElevation = self.afterElevation
            completionHandler(elevationGainString)
        }
        task.resume()
    }
    
    func calculateElevationGain() {
        if afterElevation > beforeElevation {
            elevationGain += afterElevation - beforeElevation
        }
    }
    
    func setDataToSave(elevationGain: Double?, memo: String?) {
        let newData = RealmData()
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        
//        let formatter = DateFormatter()
//        formatter.timeStyle = .full
//        formatter.dateStyle = .long
//        formatter.locale = Locale(identifier: "ja_JP")
//
//        newData.date = formatter.string(from: Date())
        newData.id = NSUUID().uuidString
        newData.elevation = elevationGain ?? 0.0
        newData.memo = memo ?? ""
        
        save(data: newData)
        
//        afterElevation = 0.0
//        beforeElevation = pow(10, 10)
//        elevationGain = 0.0
    }
    
    func save(data: RealmData) {
        do{
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving data, \(error)")
        }
    }
    
    func updateData(_ id: String, memo: String?) {
        let item: Results<RealmData> = realm.objects(RealmData.self).filter("id == %@", id)
        do {
            try realm.write {
                item.first?.memo = memo ?? ""
            }
        } catch {
            print("Error updating data, \(error)")
        }
        
    }
    
    func getDataFromRealm() {
        model = realm.objects(RealmData.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func getDataSortedByElevation () {
        model = realm.objects(RealmData.self).sorted(byKeyPath: "elevation", ascending: false)
    }
    
    func countNumberOfData() -> Int {
        return model?.count ?? 0
    }
    
    func indexData(_ index: Int) -> RealmData? {
        guard let model = model  else { return nil }
        if model.count > index {
            return model[index]
        } else {
            return nil
        }
    }
    
    func calculateToatalElevation() -> Double? {
        return model?.sum(ofProperty: "elevation") ?? 0.0
    }
    
    func deleteData(_ indexPath: IndexPath) {
        if let elevationForDeletion = model?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(elevationForDeletion)
                }
            } catch {
                print("Error deleting elevation \(error)")
            }
        }
    }
}
