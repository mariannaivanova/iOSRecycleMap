//
//  PointModel.swift
//  test
//
//  Created by Marianna Ivanova on 25.04.2023.
//

import Foundation
import MapKit



public struct PointPointJSON : Decodable {
    var isSucess: Bool?
    var data: PointPointData?
    
}

public struct PointPointData : Decodable {
    var pointId : Int
    var title: String
    var address: String?
    var geom: String?
    var restricted: Bool?
    var fractions: Array<PointFraction>?
    var businesHoursState: PointState?
    var rating: PointRating?
    var numberOfComments: Int?
    var addressDescription : String?
    var pointDescription: String?
    var schedule: Array<PointSchedule>?
    var scheduleDescription : String?
    var precise: Bool?
    var photos : Array<PointPhoto>?
    var validDates: Array<PointValid>?
    var `operator`: PointOperator?
    var lastUpdate: String?
    var moderators: Array<String>?
    var comments: Array<Comment>?
}

public struct PointValid : Decodable {
    var validFrom : String?
    var validThrough : String?
}

public struct PointFraction : Decodable {
    var id: Int?
    var name: String?
    var color: String?
    var icon: String?
}

public struct PointPhoto: Decodable {
    var photo_id: Int?
    var order: Int?
    var path: String?
    var thumb: String?
}

public struct PointRating: Decodable {
    var likes: Int?
    var dislikes: Int?
    var score: Double?
}

public struct PointState: Decodable {
    var state: String?
    var nextStateTime: String?
}

public struct PointSchedule: Decodable {
    var dow: Int?
    var opens: Array<String>?
    var closes: Array<String>?
}

public struct PointOperator: Decodable {
    var operatorId: Int?
    var title: String?
    var address: String?
    var phones: Array<String>?
    var emails: Array<String>?
    var sites: Array<String>?
}

public struct PointComment : Decodable {
    var commentId: Int?
    var message: String?
    var parentCommentId : Int?
    var timestamp: String?
    var user: User?
    var photoset: Array<Photo>?
    var edited: Bool?
    var commentStatus: String?
}

public struct PointUser : Decodable {
    var firstName: String?
    var surname: String?
    var avatar: String?
    var role: String?
}

public struct PointAnnotations {
    var annotations: Array<MKPointAnnotation>
    init(annotations: Array<MKPointAnnotation>) {
        self.annotations = annotations
    }
}

public class Annotation : MKPointAnnotation {
    let id : String?
    let name: String?
    let fractions: Array<String>?
    let address : String?
    let schedule: Array<String>?
    init (id: String, name: String, fractions: Array<String>, address: String, schedule: Array<String>) {
        self.id = id
        self.name = name
        self.fractions = fractions
        self.address = address
        self.schedule = schedule
    }
    
}


extension Annotation {
    public func parsePoint(id: String) -> Annotation  {
        guard let url = URL(string: "https://recyclemap-api-master.rc.geosemantica.ru/public/points/\(id)") else { return Annotation(id: "", name: "", fractions: [], address: "", schedule: [])}
        let session = URLSession.shared
        var name = ""
        var fractions = [] as Array<String>
        var address = ""
        var schedule = [] as Array<String>
        session.dataTask(with: url) { data, response, error in
            
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let mem = try JSONDecoder().decode(PointPointJSON.self, from: data)
                let n = mem.data?.title
                var endSkip = ")".count
                var endIndex = n!.index(n!.endIndex, offsetBy: -endSkip)
                var range = ...endIndex
                name = String(n![range])
                
                let a = mem.data?.address
                endSkip = ")".count
                endIndex = a!.index(a!.endIndex, offsetBy: -endSkip)
                range = ...endIndex
                address = String(a![range])
                
                let f = mem.data?.fractions
                for i in f ?? [] {
                    fractions.append(String(i.id ?? -1))
                }
                
                let s = mem.data?.schedule
                let o = s?[0].opens?[0]
                endSkip = ")".count
                endIndex = o!.index(o!.endIndex, offsetBy: -endSkip)
                range = ...endIndex
                let opens = o![range]
                
                let c = s?[0].closes?[0]
                endSkip = ")".count
                endIndex = c!.index(c!.endIndex, offsetBy: -endSkip)
                range = ...endIndex
                let closes = c![range]
                
                schedule.append(String(opens))
                schedule.append(String(closes))


                
            } catch let error {
                print(error)
            }
            
        }.resume()
        sleep(5)
        return Annotation(id: id, name: name, fractions: fractions, address: address, schedule: schedule)
    }
    
}
