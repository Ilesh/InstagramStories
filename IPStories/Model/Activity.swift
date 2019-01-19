//
//  Activity.swift
//
//
//  Created by Ilesh Panchal
//  Copyright © 2017 IP. All rights reserved.
//

import UIKit

class Activity: NSObject {
    var id: Int
    var action: String
    var timeAgo: String
    var author: Author
    var subject: Any
    var comments = [String]()
    var likes = [String]()
    var seenBy = [Any]()
    var commentsCount = 0
    var likesCount = 0
    var seen : Bool = true
    
    
    required init?(id: Int, action: String, timeAgo: String, author: Author, subject: Any, comments: [String], likes: [String], commentsCount: Int, likesCount: Int,seen:Bool) {
        self.id = id
        self.action = action
        self.timeAgo = timeAgo
        self.author = author
        self.subject = subject
        self.comments = comments
        self.likes = likes
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.seen = seen
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Activity]
    {
        var models:[Activity] = []
        for item in array
        {
            if let dic = item as? [String:Any] {
                if let model = Activity(json: dic) {
                  models.append(model)
                }
            }            
        }
        return models
    }
    
    convenience init?(json: [String: Any]) {        
        guard let id = json["id"] as? Int,            
            let timeAgo = json["time_ago"] as? String,
            let subjectJson = json["subject"] as? [String: Any] else {
                return nil
        }
        var author : Author!
        if let data = json["author"] as? [String: Any], let value = Author(json:data){
            author = value
        }else if let data = json["written_by"] as? [String: Any], let value = Author(json:data){
            author = value
        }else if let data = subjectJson["written_by"] as? [String: Any], let value = Author(json:data){
            author = value
        }
        else{
            author = Author(id: 0 , name: "", username: "")
        }
        
        var subject: Any? = nil
        let action = json["action"] as? String ?? ""
        let seen = json["seen"] as? Bool ?? false                
        if action == "post_created" {
            subject = Post(json: subjectJson)
        }
        else if action == "review_created" {
            //subject = Review(json: subjectJson)
        }else if action == "job_post_shared" {
            //subject = JobPostShare(dictionary: subjectJson as NSDictionary)
        }
        
        if subject == nil {
            return nil
        }
        
        var comments = [String]()
        
        if let commentsAttributes = json["comments"] as? [[String: Any]] {
            for commentAttributes in commentsAttributes {
                
            }
        }
        
        var likes = [String]()
        
        if let likesttributes = json["likes"] as? [[String: Any]] {
            for likeAttributes in likesttributes {
               ///
            }
        }
        
        var commentsCount = 0
        if let count = json["comments_count"] as? Int {
            commentsCount = count
        }
        
        var likesCount = 0
        if let count = json["likes_count"] as? Int {
            likesCount = count
        }
        
        self.init(
            id: id,
            action: action,
            timeAgo: timeAgo,
            author: author,
            subject: subject!,
            comments: comments,
            likes: likes,
            commentsCount: commentsCount,
            likesCount: likesCount,
            seen : seen
        )
    }
    
    /*convenience init?(post: Post) {
        self.init(
            id: post.id,
            action: "create_post",
            timeAgo: post.timeAgo,
            author: post.author,
            subject: post,
            comments: [String](),
            likes: [String](),
            commentsCount: 0,
            likesCount: 0
        )
    }*/
    
    func description() -> String {
        return "[Activity] ID: \(id) action: \(action)"
    }
}
