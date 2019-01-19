//
//  Singleton.swift
//  IPStories
//
//  Created by Ilesh Panchal
//  Copyright © 2019 IP. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    static let shared = Singleton()
    
    var timer : Timer?
}
