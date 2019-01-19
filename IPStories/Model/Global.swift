//
//  Global.swift
//  IPStories
//
//  Created by Ilesh Panchal
//  Copyright © 2019 IP. All rights reserved.
//

import UIKit

class Global: NSObject {

    // MARK:- Delay function
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
