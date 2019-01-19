//
//  CollectionHighlightCell.swift
//
//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.
//

import UIKit


class CollectionHighlightCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnHighlite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        // Initialization code
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.layer.masksToBounds = true
    }
    
    //NOT USED NOW
    func loadNibData(data:HightLightsModel){
        btnPost.isHidden = true
        let strUrl = data.avatar_url ?? ""
        if let url = URL(string: strUrl) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "missing-avatar"), options: .cacheMemoryOnly, completed: nil)
        }else{
            self.imgProfile.image = #imageLiteral(resourceName: "missing-avatar")
        }
        lblTitle.text = data.name ?? ""
    }
}
