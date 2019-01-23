//
//  DashboardVC.swift
//  IPStories
//
//  Created by Ilesh Panchal
//  Copyright © 2019 IP. All rights reserved.
//

import UIKit
//import JPVideoPlayer  //CLEAR VIDEO CACHE
class DashboardVC: UIViewController {

    //MARK:- IBOUTLET VARIABLE
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- VARIABLE
    private var activities = [Activity]()
    var transition: JTMaterialTransition?
    
    //MARK:- VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CLEAR VIDEO CACHE
        
        /*JPVideoPlayerCache.shared().clearDisk {
            print("Clean up all Video Data")
        }
        */
        
        UIApplication.shared.statusBarStyle = .lightContent
        //setNeedsStatusBarAppearanceUpdate()
        tableView.register(UINib(nibName: "HighlightsPostCell", bundle: nil), forCellReuseIdentifier: "HighlightsPostCell")
        self.title = "Highlights"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK:- BUTTON ACTIONMETHODS
    
    
    //MARK:- CALLER METHODS
    
    
    //MARK:- CUSTOM METHODS
    
    
    //MARK:- VIEW CYCYLE END
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
//MARK: - EXTENTION OF TABLEVIEW DELEGATE AND DATA SOURCE
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let aCell = tableView.dequeueReusableCell(withIdentifier: "HighlightsPostCell") as! HighlightsPostCell
            aCell.selectionStyle = .none
            aCell.delegate = self
            return aCell
        }
        else{
            return UITableViewCell()
        }
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
extension DashboardVC: HighlightsPostCellDelegate {
    func didTapOnCreateHighlight() {
        
    }
    
    func didTapOnShowHighlight(arrData: [HightLightsModel], index: Int, view: UIView) {
        DispatchQueue.main.async {
            self.transition = JTMaterialTransition(animatedView: view)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollectionHighlightDetailsVC") as! CollectionHighlightDetailsVC
            vc.modalPresentationStyle = .fullScreen
            vc.transitioningDelegate = self.transition
            vc.modalPresentationStyle = .overFullScreen
            vc.arrAllHighlights = arrData
            vc.view.backgroundColor = UIColor.black
            vc.currentIndex = index
            self.present(vc, animated: true, completion: nil)
        }
    }
}
extension UINavigationController {
    /**
     It removes all view controllers from navigation controller then set the new root view controller and it pops.
     
     - parameter vc: root view controller to set a new
     */
    func initRootViewController(vc: UIViewController, transitionType type: String = kCATransitionFade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition(transitionType type: String = kCATransitionFade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
}
