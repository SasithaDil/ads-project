//
//  AdPost.swift
//  nibm
//
//  Created by Sasitha Dilshan on 2022-03-23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct AdPost: Identifiable, Codable{
    @DocumentID var id: String?
    var title: String
    var seller: String
    var adContent: [adContent]
    var date: Timestamp
    
    enum CodingKeys: String,CodingKey{
        case id
        case title
        case seller
        case adContent
        case date
    }
}

struct adContent: Identifiable,Codable{
    var id = UUID().uuidString
    var value: String
    var type: AdType
    
    var height: CGFloat = 0
    var showImage: Bool = false
    var showDeleteAlert: Bool = false
    
    
    enum CodingKeys: String,CodingKey{
//        case id
        case type = "key"
        case value
        
    }
}

enum AdType: String,CaseIterable,Codable{
    case Header = "Header"
    case SubHeader = "SubHeader"
    case Description = "Description"
    case Image = "Image"
}
