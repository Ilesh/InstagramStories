//
//  PostImage.swift
//
//  Created by Ilesh Panchal
//  Copyright © 2017 IP. All rights reserved.
//

import UIKit

enum PostImageType: String {
    case image = "image"
    case video = "video"
}

class PostImage: NSObject {
    var id: Int
    var type: PostImageType
    var originalUrl: URL
    var thumbUrl: URL
    var scaledUrl: URL?
    var width: CGFloat
    var height: CGFloat
    
    required init?(id: Int, type: PostImageType, originalUrl: URL, thumbUrl: URL, scaledUrl: URL?, width: CGFloat, height: CGFloat) {
        self.id = id
        self.type = type
        self.originalUrl = originalUrl
        self.scaledUrl = scaledUrl
        self.thumbUrl = thumbUrl
        self.width = width
        self.height = height
    }
    
    convenience init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let media = json["media"] as? [String: Any?],
            let typeString = json["type"] as? String else {
                return nil
        }
        let width = json["width"] as? CGFloat ?? 0.0
        let height = json["height"] as? CGFloat ?? 0.0
        
        guard var originalUrl = media["original_url"] as? String,
            var thumbUrl = media["thumb_url"] as? String else {
                return nil
        }
        //FOR RESOLVED CRASH BAD URL
        originalUrl = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        thumbUrl = thumbUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var scaledUrl: URL? = nil
        if var url = media["scaled_url"] as? String {
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            scaledUrl = URL(string: url)
        }
        
        self.init(
            id: id,
            type: PostImageType(rawValue: typeString)!,
            originalUrl: URL(string: originalUrl)!,
            thumbUrl: URL(string: thumbUrl)!,
            scaledUrl: scaledUrl,
            width: width,
            height: height
        )
    }
    
    func description() -> String {
        return "[PostImage] ID: \(id) url: \(originalUrl.description)"
    }
}
