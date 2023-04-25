//
//  MapModel.swift
//  test
//
//  Created by Marianna Ivanova on 20.04.2023.
//

import Foundation

struct PointJSON : Decodable {
    var isSucess: Bool?
    var data: PointData?
    
}

struct PointData : Decodable {
    var pointId : Int?
    var address: String?
    var addressDescription: String?
    var pointDescription: String?
    var geom: String?
    var precise: String?
    var restricted: Bool?
    var title: String?
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

struct Fraction : Decodable {
    var id: Int?
    var name: String?
    var color: String?
    var icon: String?
}

struct Photo: Decodable {
    var photo_id: Int?
    var order: Int?
    var path: String?
    var thumb: String?
}

struct Rating: Decodable {
    var likes: Int?
    var dislikes: Int?
    var score: Double?
}

struct State: Decodable {
    var state: String?
    var nextStateTime: String?
}

struct Schedule: Decodable {
    var dow: Int?
    var opens: Array<String>?
    var closes: Array<String>?
}

struct Operator: Decodable {
    var operatorId: Int?
    var title: String?
    var address: String?
    var phones: Array<String>?
    var emails: Array<String>?
    var sites: Array<String>?
}

struct Comment : Decodable {
    var commentId: Int?
    var message: String?
    var parentCommentId : Int?
    var timestamp: String?
    var user: User?
    var photoset: Array<Photo>?
    var edited: Bool?
    var commentStatus: String?
}

struct User : Decodable {
    var firstName: String?
    var surname: String?
    var avatar: String?
    var role: String?
}



//extension PointJSON {
//    func parsePoints() ->
//}
