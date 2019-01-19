//
//  CollectionHighlightDetailsVC.swift

//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

//MARK: CollectionPushAndPoppable
class CollectionHighlightDetailsVC: UIViewController {

    private let animators: [(LayoutAttributesAnimator, Bool, Int, Int)] = [(ParallaxAttributesAnimator(), true, 1, 1),
                                                                          (ZoomInOutAttributesAnimator(), true, 1, 1),
                                                                          (RotateInOutAttributesAnimator(), true, 1, 1),
                                                                          (LinearCardAttributesAnimator(), false, 1, 1),
                                                                          (CubeAttributesAnimator(), true, 1, 1),
                                                                          (CrossFadeAttributesAnimator(), true, 1, 1),
                                                                          (PageAttributesAnimator(), true, 1, 1),
                                                                          (SnapInAttributesAnimator(), true, 2, 4)]
    
    @IBOutlet weak var collectionStories: UICollectionView!
    @IBOutlet var dismissGesture: UISwipeGestureRecognizer!
    
    var arrAllHighlights:[HightLightsModel] = []
    var currentIndex : Int = 0
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionView.ScrollDirection = .horizontal
    
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = (CubeAttributesAnimator(), true, 1, 1)
        collectionStories?.isPagingEnabled = true
        
        collectionStories.register(UINib(nibName: "HighlightsUserCell", bundle: nil), forCellWithReuseIdentifier: "HighlightsUserCell")
        
        if let layout = collectionStories?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
        
       dismissGesture.direction = direction == .horizontal ? .down : .left
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        Global().delay(delay:0.2) {
            let nextIndexpath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionStories.scrollToItem(at: nextIndexpath, at: .right, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if Singleton.shared.timer != nil {
            Singleton.shared.timer!.invalidate()
        }
        super.viewDidDisappear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool { return true }

}

extension CollectionHighlightDetailsVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllHighlights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightsUserCell", for: indexPath) as! HighlightsUserCell
        cell.highlight = arrAllHighlights[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.sendDissmissBlock = {
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: self.collectionStories.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HighlightsUserCell {
            self.selectedIndexPath = indexPath
            print("Will Display \(String(describing: cell.indexPath))")
            print("Will Display \(String(describing: cell.self))")
            cell.will_display()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.selectedIndexPath != indexPath {
            if let cell = cell as? HighlightsUserCell {
                print("Did Display \(String(describing: cell.indexPath))")
                print("Did Display \(String(describing: cell.self))")
                cell.did_display()
            }
        }else{
            print("selectedIndexPath \(String(describing: selectedIndexPath))")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("test")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("test")
    }    
}

extension CollectionHighlightDetailsVC: HighlightsUserCellDelegate {
    func nextUser(index: IndexPath) {
        if (arrAllHighlights.count) > index.row + 1{
            // SCROLL NEXT PAGE.
            let nextIndexpath = IndexPath(row: index.row + 1, section: index.section)
            self.collectionStories.scrollToItem(at: nextIndexpath, at: .centeredHorizontally, animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func previourUser(index: IndexPath) {
        let previousIndex = index.row - 1
        if previousIndex < 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            let nextIndexpath = IndexPath(row: index.row - 1, section: index.section)
            self.collectionStories.scrollToItem(at: nextIndexpath, at: .centeredHorizontally, animated: true)
        }
    }
}
