//
//  HighlightsUserCell.swift
//
//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.
//

import UIKit
import SDWebImage
//import MBProgressHUD
import JPVideoPlayer

class HightLightsImgesModel : NSObject {
    var id: Int = 0
    var timeAgo: String = ""
    var originalUrl: String = ""
    var is_seen : Bool = false
    var type: PostImageType = .image
    
    override init() {
        
    }
}

protocol HighlightsUserCellDelegate {
    func nextUser(index:IndexPath)
    func previourUser(index:IndexPath)
}

class HighlightsUserCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var viewVideo: UIView!
    
    var delegate : HighlightsUserCellDelegate?
    var indexPath : IndexPath!
    
    var arrProgress : [UIProgressView] = []
    let spaceBetweenBar : CGFloat = 5.0
    let timeImageDisplay = 600 //milisecond
    var seconds = 0
    
    var timer = Timer(){
        didSet{
            print("did Set called of timer")
            Singleton.shared.timer = timer
        }
    }

    var highlight : HightLightsModel!
    private var arrImages : [HightLightsImgesModel] = []
    
    var index = 0
    var isVideo:Bool = false
    
    var is_mute:Bool = true {
        didSet{
            if is_mute {
                self.btnSound.setImage(#imageLiteral(resourceName: "icon-volume-off"), for: .normal)
            }else{
                self.btnSound.setImage(#imageLiteral(resourceName: "icon-volume-on"), for: .normal)
            }
        }
    }
    
    //Current Progress
    var progressCurrent:UIProgressView!
    //var progressLoader = MBProgressHUD()
    
    //REFRESH FLAGE
    var sendBlocOFRefresh :(()->Void)?
    var sendDissmissBlock :(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                        
        self.is_mute = true
        self.btnSound.isHidden = true
        
        let swipeDownOnNext = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDownOnNext.direction = UISwipeGestureRecognizer.Direction.down
        self.btnNext.addGestureRecognizer(swipeDownOnNext)
        
        //SWIP DOWN
        let swipeDownOnPrevios = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDownOnPrevios.direction = UISwipeGestureRecognizer.Direction.down
        self.btnPrevious.addGestureRecognizer(swipeDownOnPrevios)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewVideo.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    //MARK:- WILL DISPLAY CELL
    func will_display(){
        timer.invalidate()
        self.removeArrProgress()
        self.SetHighlightsWithIndex()
    }
    
    
    //MARK: END DISPLAY CELL
    func did_display(){
        timer.invalidate()
        self.removeArrProgress()
        if let data = highlight, data.isSeen {
            self.checkAllSeenOrnot()
        }
        self.viewVideo.jp_stopPlay()
    }
    
    func SetHighlightsWithIndex(){
        var i = 0
        self.arrImages.removeAll()
        self.index = 0
        highlight.activities?.forEach({ (activity) in
            if let post = activity.subject as? Post {
                if post.images.count > 0 {
                    post.images.forEach({ (postImg) in
                        let data : HightLightsImgesModel = HightLightsImgesModel()
                        data.id = post.id
                        data.type = postImg.type
                        data.timeAgo = post.timeAgo
                        data.originalUrl = postImg.originalUrl.absoluteString
                        if highlight.isSeen {
                            data.is_seen = true
                        }else{
                            if !activity.seen {
                                if self.index == 0 {
                                    self.index = i
                                }
                            }
                            data.is_seen = activity.seen
                        }
                        self.arrImages.append(data)
                    })
                }else{
                    i -= 1 // Fix for now but backend issue.
                }
                i += 1
            }
        })
        self.setDataOnViews()
        self.imageAvatar.image = #imageLiteral(resourceName: "missing-avatar")
        if let url = URL(string: highlight.avatar_url ?? "") {
            self.imageAvatar.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "missing-avatar"), options: .cacheMemoryOnly, completed: nil)
        }
        lblName.text = highlight.name ?? ""
    }
    
    func setDataOnViews() -> Void {
        if arrImages.count > 0 {
            self.arrProgress.forEach { (old) in
                old.removeFromSuperview()
            }
            self.arrProgress.removeAll()
            let totalSpacebtwProgress = self.arrImages.count > 0 ? self.arrImages.count - 1: 0
            let width = ((UIScreen.main.bounds.width - 20) - (CGFloat(totalSpacebtwProgress) * spaceBetweenBar))/CGFloat(self.arrImages.count)
            for index in 0..<arrImages.count {
                let progress = UIProgressView(frame: CGRect(x: (CGFloat(index) * (width + spaceBetweenBar)) , y: 5.0, width: width, height: 10.0))
                //print("Frame \(progress.frame)")
                //progress.progressViewStyle = .default
                progress.progressTintColor = UIColor.white
                progress.trackTintColor = UIColor.white.withAlphaComponent(0.2)
                progress.layer.cornerRadius = 2.0
                progress.layer.masksToBounds = true
                if index < self.index {
                    progress.setProgress(1.0, animated: false)
                }else{
                    progress.setProgress(0.0, animated: false)
                }
                progress.transform = progress.transform.scaledBy(x: 1.0, y: 2.0)
                self.arrProgress.append(progress)
                self.viewProgress.addSubview(progress)
            }
            self.setImages(index: index)
        }
        else{
            print("No post")
        }
    }
    
    //MARK:- IMAGE SETUP METHDOS
    func setImages(index:Int){
        if self.arrImages.count > 0 {
            if  self.arrImages.count > index {
                lblTime.text = self.arrImages[index].timeAgo
                if let urlImage =  URL(string: self.arrImages[index].originalUrl) {
                    if self.arrImages[index].type == .image {
                        self.isVideo = false
                        self.viewVideo.isHidden = true
                        self.imgView.isHidden = false
                        self.btnSound.isHidden = true
                        //MBProgressHUD.hide(for: self.imgView, animated: true)
                        //MBProgressHUD.showAdded(to: self.imgView, animated: true)
                        self.imgView.sd_setImage(with: urlImage, placeholderImage: nil, options: .highPriority, completed: { (image, error,catchSd, url) in
                           // MBProgressHUD.hide(for: self.imgView, animated: true)
                            if (image != nil) {
                                self.runTimer()
                                DispatchQueue.main.async {
                                    self.setUpProgress()
                                }
                                self.imgView.image = image
                                if(self.arrImages.count - 1) >= index{
                                    if !self.arrImages[index].is_seen {
                                        self.arrImages[index].is_seen = true
                                    }
                                }
                            }
                        })
                    }else{
                        //print("Video Type")
                        self.isVideo = true
                        self.timer.invalidate()
                        self.btnSound.isHidden = false
                        self.imgView.isHidden = true
                        self.viewVideo.isHidden = false
                        self.viewVideo.frame = CGRect(x: 0, y:self.bounds.origin.y, width: UIScreen.main.bounds.width, height: self.bounds.height)
                        self.viewVideo.jp_videoPlayerView?.frame = CGRect(x: 0, y:self.bounds.origin.y, width: UIScreen.main.bounds.width, height:self.bounds.height)
                        self.viewVideo.jp_videoPlayerView?.contentMode = .scaleToFill
                        
                        self.viewVideo.jp_playVideo(with: urlImage)
                        self.viewVideo.jp_videoPlayerDelegate = self
                        self.runTimer()
                        Global().delay(delay: 0.2) {
                            self.viewVideo.jp_muted = self.is_mute
                        }
                        DispatchQueue.main.async {
                            self.setUpProgress()
                        }                                                
                    }
                }
            }else{
                self.delegate?.nextUser(index: self.indexPath)
            }
        }
    }
    
    //MARK:- DEALLOC METHODS
    func removeArrProgress() -> Void {
        for element in viewProgress.subviews {
            element.removeFromSuperview()
        }
        self.viewProgress.subviews.forEach({ $0.removeFromSuperview() })
        self.arrProgress.removeAll()
    }
    
    func checkAllSeenOrnot(){
        var isallSeen = true
        for model in self.arrImages {
            if !model.is_seen{
                isallSeen = false
                break
            }
        }
        if isallSeen{
            highlight.isSeen = true
            self.sendBlocOFRefresh?()
        }
    }
    
    //MARK:- TIMEAR AND PROGRESS METHODS
    func runTimer(isPused:Bool = false) {
        if !isPused {
            seconds = 0
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func setUpProgress(isvideo:Bool = false){
        guard index >= 0 else {return}
        if arrProgress.count > index {
            progressCurrent = arrProgress[index]
            if isvideo {
                self.progressCurrent.setProgress(1.0, animated: false)
            }else{
                self.progressCurrent.setProgress(0.0, animated: false)
            }
        }
    }
    
    @objc func updateTimer() {
        seconds += 1
        //print("\(seconds)")
        if self.isVideo {
            if let current = self.viewVideo.jp_videoPlayerView?.jp_currentTime(),let total = self.viewVideo.jp_videoPlayerView?.jp_totalSeconds(){
                print("Current Timer \(Float(CMTimeGetSeconds(current))) ---> Total Timer \(Float(total)) === Progress \(Float(CMTimeGetSeconds(current))/Float(total))")
                if Float(CMTimeGetSeconds(current))/Float(total) > 0.01 {
                    self.progressCurrent.setProgress(Float(CMTimeGetSeconds(current))/Float(total), animated: true)
                }
            }
        }else{
            if self.progressCurrent != nil {
                self.progressCurrent.setProgress(Float(self.seconds)/Float(self.timeImageDisplay), animated: true)
            }
            if self.seconds == self.timeImageDisplay{
                self.stopTimer()
            }
        }
        /*DispatchQueue.main.async {
            
        }*/
    }
    
    func stopTimer() -> Void {
        timer.invalidate()
        index += 1
        self.setImages(index: index)
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        timer.invalidate()
        self.removeArrProgress()
        if let data = highlight, data.isSeen {
            self.checkAllSeenOrnot()
        }
        self.viewVideo.jp_stopPlay()
        print("btnCloseClick")
        self.sendDissmissBlock?()
    }
    
    @IBAction func btnSoundClick(_ sender: Any) {
        if self.is_mute {
            self.is_mute = false
            self.viewVideo.jp_muted = false
        }else{
            self.is_mute = true
            self.viewVideo.jp_muted = true
        }
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        timer.invalidate()
        if progressCurrent != nil {
            progressCurrent.setProgress(1.0, animated: false)
        }
        self.viewVideo.jp_stopPlay()
        index += 1
        self.setImages(index: index)
    }
    
    @IBAction func btnPreviousClick(_ sender: Any) {
        if progressCurrent != nil {
            progressCurrent.setProgress(0.0, animated: false)
        }
        timer.invalidate()
        index -= 1
        if index < 0 {
            self.delegate?.previourUser(index: self.indexPath)
        }else{
            self.setImages(index: index)
        }
    }
    
    //MARK:- SWIPE DOWN ACTION METHODS
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                self.btnCloseClick(self)
                break;
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
}
//MARK:- JPVideo Player Delegates
extension HighlightsUserCell : JPVideoPlayerDelegate{
    func playerStatusDidChanged(_ playerStatus: JPVideoPlayerStatus) {
        
    }
    
    func shouldAutoReplay(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldAutoReplay")
        if progressCurrent != nil {
            progressCurrent.setProgress(1.0, animated: false)
        }
        self.stopTimer()
        return false
    }
    
    func shouldDownloadVideo(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldDownloadVideo")
        return true
    }
    
    func shouldShowDefaultControlAndIndicatorViews() -> Bool {
        print("------------------------------------------------------------------->shouldShowDefaultControlAndIndicatorViews")
        return true
    }
    
    func shouldShowBlackBackgroundBeforePlaybackStart() -> Bool {
        print("------------------------------------------------------------------->shouldShowBlackBackgroundBeforePlaybackStart")
        return true
    }
    
    func shouldShowBlackBackgroundWhenPlaybackStart() -> Bool {
         print("------------------------------------------------------------------->shouldShowBlackBackgroundWhenPlaybackStart")
        return true
    }
    
    func shouldAutoHideControlContainerViewWhenUserTapping() -> Bool {
        print("------------------------------------------------------------------->shouldAutoHideControlContainerViewWhenUserTapping")
        return true
    }
    
    func shouldTranslateIntoPlayVideoFromResumePlay(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldTranslateIntoPlayVideoFromResumePlay")
        return true
    }
    
    func shouldPausePlaybackWhenApplicationWillResignActive(for videoURL: URL) -> Bool {
         print("------------------------------------------------------------------->shouldPausePlaybackWhenApplicationWillResignActive")
        return true
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
         print("------------------------------------------------------------------->shouldUpdateFocus")
        return true
    }
    
    func shouldPausePlaybackWhenApplicationDidEnterBackground(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldPausePlaybackWhenApplicationDidEnterBackground")
        return true
    }
    
    func shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackground(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackground")
        return true
    }
    
    func shouldPausePlaybackWhenReceiveAudioSessionInterruptionNotification(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldPausePlaybackWhenReceiveAudioSessionInterruptionNotification")
        return true
    }
    
    func shouldResumePlaybackWhenApplicationDidBecomeActiveFromResignActive(for videoURL: URL) -> Bool {
        print("------------------------------------------------------------------->shouldResumePlaybackWhenApplicationDidBecomeActiveFromResignActive")
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("------------------------------------------------------------------->gestureRecognizerShouldBegin")
        return true
    }
    
    override func jp_playVideo(with url: URL, options: JPVideoPlayerOptions = [], configuration: JPPlayVideoConfiguration? = nil) {
        print("------------------------------------------------------------------->configuration")
    }
    
    func shouldResumePlaybackFromPlaybackRecord(for videoURL: URL, elapsedSeconds: TimeInterval) -> Bool {
        print("shouldResumePlaybackFromPlaybackRecord\(elapsedSeconds)")
        return true
    }
    
}

extension HighlightsUserCell : JPVideoPlayerInternalDelegate{
    func videoPlayer(_ videoPlayer: JPVideoPlayer, didReceiveLoadingRequest requestTask: JPResourceLoadingRequestWebTask) {
        print("didReceiveLoadingRequest")
    }
    
    func videoPlayerPlayProgressDidChange(_ videoPlayer: JPVideoPlayer, elapsedSeconds: Double, totalSeconds: Double) {
        print("videoPlayerPlayProgressDidChange\(elapsedSeconds)")
    }
}
