//
//  HighlightsPostCell.swift
//
//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.
//

import UIKit

protocol HighlightsPostCellDelegate {
    func didTapOnCreateHighlight()
    func didTapOnShowHighlight(arrData:[HightLightsModel],index:Int,view:UIView)
}

class HighlightsPostCell: UITableViewCell {
    
    @IBOutlet weak var collectionHighlight: UICollectionView!
    var arrHighlight : [HightLightsModel] = []
    var delegate:HighlightsPostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionHighlight.register(UINib(nibName: "CollectionHighlightCell", bundle: nil), forCellWithReuseIdentifier: "CollectionHighlightCell")
        collectionHighlight.register(UINib(nibName: "CollectionUserHighlightCell", bundle: nil), forCellWithReuseIdentifier: "CollectionUserHighlightCell")
        
        
        //self.CreateSelfActivityForFirst()
        self.getHighlights()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- NOTIFICATION OBSEVER METHDOS
    @objc func refreshList(notification: NSNotification){
        if let userInfo = notification.userInfo as? [String : AnyObject] {
            let refreshCall = userInfo["refresh"] as? Bool ?? false
            if refreshCall {
                self.getHighlights()
            }else{
                self.arrHighlight.sort(by: { !$0.isSeen && $1.isSeen })
                self.arrHighlight.sort(by: { $0.author_id == 0 && $1.author_id != 0 })
                self.collectionHighlight.reloadData()
            }
        }
    }
    
    //MARK: API CALL FOR GET HIGHLITS
    @objc private func getHighlights() {
        if let path = Bundle.main.path(forResource: "Highlights", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonArray = jsonResult as? [[String:Any]] {
                    print(jsonArray)
                    self.arrHighlight.removeAll()
                    for item in jsonArray {
                        if let activity = HightLightsModel(dictionary: item as NSDictionary) {
                            self.arrHighlight.append(activity)
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
}

extension HighlightsPostCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrHighlight.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aHighLighCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionUserHighlightCell", for: indexPath) as! CollectionUserHighlightCell
        aHighLighCell.btnHighlite.tag = indexPath.item
        aHighLighCell.btnHighlite.addTarget(self, action: #selector(btnHighlitsClick(_:)), for: .touchUpInside)
        aHighLighCell.loadNibData(data:self.arrHighlight[indexPath.item])
        return aHighLighCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print("Click Collection cell \(indexPath.item)")
    }
    
    @objc func btnHighlitsClick(_ sender:UIButton){
        print("btnHighlitsClick \(sender.tag)")
        if let cell = self.collectionHighlight.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? CollectionUserHighlightCell{
            delegate?.didTapOnShowHighlight(arrData: self.arrHighlight, index: sender.tag,view: cell.imgProfile)
        }
    }
}

