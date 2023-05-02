//
//  MapModel.swift
//  test
//
//  Created by Marianna Ivanova on 20.04.2023.
//

import Foundation
import MapKit



public struct Rectangle {
    var west : String
    var south : String
    var east : String
    var north : String
}

public struct PointJSON : Decodable {
    var isSucess: Bool?
    var data: DataJSON?
    
}

public struct DataJSON : Decodable {
    var totalResults: Int?
    var points: Array<PointData>?
}

public struct PointData : Decodable {
    var pointId : Int
    var address: String?
    var addressDescription: String?
    var pointDescription: String?
    var geom: String?
    var precise: String?
    var restricted: Bool?
    var title: String
    var scheduleDescription: String?
    var fractions: Array<Fraction>?
    var photos: Array<Photo>?
    var rating: Rating?
    var businesHoursState: State?
    var numberOfComments: Int?
    var schedule: Array<Schedule>?
    var validDates: Array<String>?
    var `operator`: Operator?
    var lastUpdate: String?
    var moderators: Array<String>?
    var comments: Array<Comment>?
}

public struct Fraction : Decodable {
    var id: Int?
    var name: String?
    var color: String?
    var icon: String?
}

public struct Photo: Decodable {
    var photo_id: Int?
    var order: Int?
    var path: String?
    var thumb: String?
}

public struct Rating: Decodable {
    var likes: Int?
    var dislikes: Int?
    var score: Double?
}

public struct State: Decodable {
    var state: String?
    var nextStateTime: String?
}

public struct Schedule: Decodable {
    var dow: Int?
    var opens: Array<String>?
    var closes: Array<String>?
}

public struct Operator: Decodable {
    var operatorId: Int?
    var title: String?
    var address: String?
    var phones: Array<String>?
    var emails: Array<String>?
    var sites: Array<String>?
}

public struct Comment : Decodable {
    var commentId: Int?
    var message: String?
    var parentCommentId : Int?
    var timestamp: String?
    var user: User?
    var photoset: Array<Photo>?
    var edited: Bool?
    var commentStatus: String?
}

public struct User : Decodable {
    var firstName: String?
    var surname: String?
    var avatar: String?
    var role: String?
}

public struct Annotations {
    var annotations: Array<MKPointAnnotation>
    init(annotations: Array<MKPointAnnotation>) {
        self.annotations = annotations
    }
}

public class MapAnnotation : MKPointAnnotation {
    let name : String?
    let id : String?
    init (name: String, id: String) {
        self.name = name
        self.id = id
    }
}


extension Annotations {
    public func parsePoints(west: String, south: String, east: String, north: String) -> Annotations {
        var points: [MapAnnotation] = []
        guard let url = URL(string: "https://recyclemap-api-master.rc.geosemantica.ru/public/points?bbox=\(west)%2C\(south)%2C\(east)%2C\(north)&size=50&restricted=false&offset=0") else { return Annotations(annotations: [MKPointAnnotation()]) }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let mem = try JSONDecoder().decode(PointJSON.self, from: data)
                let coords = mem.data?.points
                
                for i in coords ?? [] {
                    let coord = i.geom
                    let startSkip = "Option".count
                    let endSkip = "\")".count
                    let startIndex = coord!.index(coord!.startIndex, offsetBy: startSkip)
                    let endIndex = coord!.index(coord!.endIndex, offsetBy: -endSkip)
                    let range = startIndex...endIndex
                    let c = String(coord![range])
                    
                    let d = c.components(separatedBy: " ")
                    let annotation = MapAnnotation(name: i.title, id: String(i.pointId))
                    annotation.coordinate = CLLocationCoordinate2D(
                        latitude: Double(d[1])!,
                        longitude: Double(d[0])!
                    )
                    annotation.title = i.title
                    points.append(annotation)
                    
                }
                
            } catch let error {
                print(error)
            }
            
        }.resume()
        sleep(5)
        return Annotations(annotations: points)
    }
    
}
