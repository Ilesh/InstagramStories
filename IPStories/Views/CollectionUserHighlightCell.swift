//
//  CollectionUserHighlightCell.swift
//
//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionUserHighlightCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLayer1: UIImageView!
    @IBOutlet weak var viewLayer1: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnHighlite: UIButton!
    @IBOutlet weak var viewReadUnReadProfile: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        
        imgLayer1.layer.cornerRadius = imgLayer1.frame.size.width / 2
        viewLayer1.layer.cornerRadius = viewLayer1.frame.size.width / 2
        
        viewReadUnReadProfile.layer.cornerRadius = viewReadUnReadProfile.frame.size.width / 2
        viewReadUnReadProfile.layer.masksToBounds = true
        viewReadUnReadProfile.layer.borderWidth = 3.0
        viewReadUnReadProfile.layer.borderColor = UIColor.hexString("3381a7").cgColor //Dark green
        
    }
    
    func loadNibData(data:HightLightsModel){        
        let strUrl = data.avatar_url ?? ""
        if let url = URL(string: strUrl) {
            imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "missing-avatar"), options: .cacheMemoryOnly, completed: nil)
        }else{
            self.imgProfile.image = #imageLiteral(resourceName: "missing-avatar")
        }
        lblTitle.text = data.name ?? ""
        SetBoarderWithReadUnRead(isSeen: data.isSeen)
    }
    
    func SetBoarderWithReadUnRead(isSeen:Bool) {
       
    }
}


