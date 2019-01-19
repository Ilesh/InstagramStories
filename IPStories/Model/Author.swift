//
//  Author.swift
//
//  Created by Ilesh Panchal
//  Copyright © 2017 IP. All rights reserved.
//

import UIKit

class Author: NSObject {
    var id: Int
    var name: String
    var username: String
    var mentionTag: String
    var title: String?
    // var type: RecruitdEntityType
    var avatarUrl: URL?

    required init?(id: Int, name: String, username: String,title:String?, avatarUrl: URL?,mentionTag:String) {
        self.id = id
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
        self.mentionTag = mentionTag
        self.title = title
    }
    
    convenience init?(id: Int, name: String, username: String) {
        self.init(id: 0, name: "", username: "",title: "", avatarUrl: nil, mentionTag: "")
    }
        
    convenience init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String else {
                return nil
        }
        
        let username = json["username"] as? String ?? ""
        let title = json["title"] as? String ?? ""
        let mentionTag = json["mention_tag"] as? String ?? ""
    
            
        var avatarUrl: URL? = nil
        if let avatarUrlString = json["avatar_url"] as? String {
            avatarUrl = URL(string: avatarUrlString)
        }

        self.init(
            id: id,
            name: name,
            username: username,
            title:title,
            avatarUrl: avatarUrl,
            mentionTag: mentionTag
        )
    }
}
