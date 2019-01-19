//
//  Post.swift
//
//  Created by Ilesh Panchal
//  Copyright © 2017 IP. All rights reserved.
//

import UIKit

class Post: NSObject {
    var id: Int
    var body: String
    var timeAgo: String
    var author: Author
    var images = [PostImage]()
    var metadata : String?
    
    required init?(id: Int, body: String, images: [PostImage], timeAgo: String, author: Author,metaData:String?) {
        self.id = id
        self.body = body
        self.images = images
        self.timeAgo = timeAgo
        self.author = author
        self.metadata = metaData
    }
    
    convenience init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let timeAgo = json["time_ago"] as? String,
            let author = Author(json: (json["written_by"] as? [String: Any])!) else {
                return nil
        }
        
        var images = [PostImage]()
        var metaData : String?
        if let data = json["String"] as? NSDictionary {
            //metaData = String(dictionary: data)
        }
        
        let body = json["body"] as? String ?? ""
        if let imagesAttributes = json["post_images"] as? [[String: Any]] {
            for imageAttributes in imagesAttributes {
                if let image = PostImage(json: imageAttributes) {
                    images.append(image)
                }
            }
        }
        
        self.init(
            id: id,
            body: body,
            images: images,
            timeAgo: timeAgo,
            author: author,
            metaData: metaData
        )
    }
    
    func description() -> String {
        return "[Post] ID: \(id) body: \(body)"
    }
}
