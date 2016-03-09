//
//  ViewController.swift
//  CMPlayerViewController
//
//  Created by Célian MOUTAFIS on 08/03/2016.
//  Copyright © 2016 mouce. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



/**
    This delegate let your manage the subtitle of your CMPlayerViewController
**/
protocol CMPlayerViewControllerDelegate {
    /**
     Choose the appropriate subtitle option
    */
    func prefereSubtitleMediaOption(options : [AVMediaSelectionOption]?) -> AVMediaSelectionOption?
    
}

/**
 Sample View Controller
 */
class ViewController: UIViewController, CMPlayerViewControllerDelegate {


    override func viewDidAppear(animated: Bool) {
        
        let player = CMPlayerViewController(url: "http://devstreaming.apple.com/videos/wwdc/2015/1026npwuy2crj2xyuq11/102/hls_vod_mvp.m3u8");
        player.delegate = self
        self.presentViewController(player, animated: true, completion: nil)
    }
    
    func prefereSubtitleMediaOption(options: [AVMediaSelectionOption]?) -> AVMediaSelectionOption? {
        
        if options != nil {
            for opt in options! {
                if (opt.locale?.localeIdentifier == "en"){
                    return opt
                }
            }
        }
        return nil
    }

}


extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

/**
 CMPlayerViewController is a convenient view controller to use AVPlayer in a view controller. It looks like AVPlayerViewController but it is fully customizable ans works on iOS 7
 */
class CMPlayerViewController : UIViewController {
    
    /**Manage the video progess*/
    @IBOutlet weak var mSlider: UISlider!
    /** Video Url */
    let url : String?
    /** AVplayer object linked to the view controller */
    var player : AVPlayer?
    /** AVplayerLayer object linked to the view controller */
    var avplayerlayer : AVPlayerLayer?
    /** NSTimer responsible for duration label update */
    private var timer : NSTimer?
    /** NSTimer responsible for auto hidding toolbars */
    private var visibilityTimer : NSTimer?
    /** Delegate for the View controller. Will be called for subtitle choice */
    var delegate : CMPlayerViewControllerDelegate?
    
    /** UILabel for elapsed time */
    @IBOutlet weak var elapsedTime: UILabel!
    /** UILabel for remaining time */
    @IBOutlet weak var remainingTime: UILabel!
    /** UIView containing the MPVolumeView */
    @IBOutlet weak var mVolumeContainer: UIView!
    
    /** Header view with back button, progress slider and share action */
    @IBOutlet weak var header: UIView!
    /** Footer with MPVolumeView and play/pause button */
    @IBOutlet weak var footer: UIView!
    /** Tap Gesture for toogle toolbars */
    var gesture : UITapGestureRecognizer?
    
    
    /** Play/Pause button */
    @IBOutlet weak var playButton: UIButton!
    
    /** conveninence init to pass url on loading */
    init(url : String) {
        self.url = url
        super.init(nibName: "CMPlayerViewController", bundle: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        self.url = nil
        super.init(coder: aDecoder)
    }
    
    /** Create the gesture on view loading */
    override func viewDidLoad() {
        super.viewDidLoad()
        gesture = UITapGestureRecognizer(target: self, action: "didTapView:")
        self.view.addGestureRecognizer(gesture!)
    }

    
    /** Manage the touch gesture handling */
    func didTapView(sender : AnyObject?){
        let alpha = 1 - self.header.alpha
        
        
        UIApplication.sharedApplication().setStatusBarHidden(self.header.alpha == 1, withAnimation: .Fade)
        if (alpha == 1){
            visibilityTimer?.invalidate()
            visibilityTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "didTapView:", userInfo: nil, repeats: false)
        }else{
            self.visibilityTimer?.invalidate()
            self.visibilityTimer = nil
        }
       self.prefersStatusBarHidden()
        UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
            self.header.alpha = alpha
            self.footer.alpha = alpha
            
            }, completion: nil)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return self.header.alpha == 0
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mSlider.setThumbImage(UIImage(named: "tik_player")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        if (self.url != nil) {
            if let _url = NSURL(string: self.url!)  {
                self.player = AVPlayer(URL: _url)
                self.avplayerlayer = AVPlayerLayer(player: self.player)
                var frame = CGRectZero
                frame.size = UIApplication.sharedApplication().windows.first!.frame.size
                self.avplayerlayer!.frame = frame
                self.avplayerlayer?.backgroundColor = UIColor.blackColor().CGColor
                self.play()
                self.player?.closedCaptionDisplayEnabled = true
                self.view.layer.insertSublayer(avplayerlayer!, atIndex: 0)
               self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimerLabels", userInfo: nil, repeats: true)
            }
        }
        
        self.createVolumeView()

    }
    
    /** Generate image from solid color to customize MPVolumeView in the proper way*/
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /** Create the volume view */
    private func createVolumeView() {
        
        let volumeView = MPVolumeView(frame: CGRectMake(0,0,mVolumeContainer.frame.size.width, mVolumeContainer.frame.size.height))
        self.mVolumeContainer.addSubview(volumeView)
        volumeView.setVolumeThumbImage(UIImage(named: "tik_player")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        volumeView.tintColor = UIColor.whiteColor()
        volumeView.autoresizingMask = .FlexibleWidth
        volumeView.setMaximumVolumeSliderImage(self.getImageWithColor(UIColor.blackColor(), size: CGSizeMake(1, 1)), forState: .Normal)
        
           }
    
    /** Manage time seeking using the slider */
    @IBAction private func userDidSlide(sender: UISlider) {
        self.player?.pause()
        let total = self.player!.currentItem!.duration.seconds
        self.player?.seekToTime(CMTime(seconds: total*Double(sender.value), preferredTimescale: 1))
        self.player?.play()
    }
    
    /** Update periodycally the timer labels */
    private func updateTimerLabels() {
        
        let elapsed = self.player!.currentTime().seconds
        let total = self.player!.currentItem!.duration.seconds
        
        if elapsed.isNormal && total.isNormal {
        self.elapsedTime.text = self.formateTime(Int(elapsed))
        self.remainingTime.text = self.formateTime(Int(elapsed), totalSeconds: Int(total))
            self.mSlider.setValue(Float(elapsed) / Float(total), animated: true)
        }
        else{
            self.elapsedTime.text = self.formateTime(0)
            self.remainingTime.text = self.formateTime(0)
             self.mSlider.setValue(0, animated: true)
        }
    }
    
    
    
    
    /**Open an UIActivityController with the URL of the video*/
    @IBAction func shareAction() {
        if (isPlaying()){
            self.play()
        }
        let activityItems = [self.url!]
        let shareController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        shareController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeAirDrop]
        self.presentViewController(shareController, animated: true, completion: nil)
        
    }
    
    
    /**Format time for labels with pattern MM:SS */
    func formateTime(curentSeconds : Int, totalSeconds : Int = -1) -> String {
        
        let tmp = (totalSeconds == -1) ? curentSeconds : (totalSeconds - curentSeconds)
        let seconds: Int = tmp % 60
        let minutes: Int = (tmp / 60) % 60
       // let hours: Int = totalSeconds / 3600
        return "\(totalSeconds != -1 ? "-" : "")\(minutes.format("02")):\(seconds.format("02"))"
    }
    
    /** Close the View controller */
    @IBAction func dismiss() {
        self.timer!.invalidate()
        self.timer = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /** Check if the player is currently playing*/
    func isPlaying() -> Bool {
        return (self.player!.rate != 0)
    }
    
    
    /**Toogle play/pause state*/
    @IBAction func play() {
        if (self.isPlaying()){
            //player is currently playing
            self.player?.pause()
            let group = self.player!.currentItem!.asset.mediaSelectionGroupForMediaCharacteristic(AVMediaCharacteristicLegible)
            if let option = self.delegate?.prefereSubtitleMediaOption(group?.options)
            {
                self.player?.currentItem?.selectMediaOption(option, inMediaSelectionGroup: group!)
            }
            
            self.playButton.setImage(UIImage(named: "play"), forState: .Normal)
        }else{
              self.playButton.setImage(UIImage(named: "pause"), forState: .Normal)
            self.player?.play()
        }
    }
    

    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        var frame = self.view.frame
    
        switch toInterfaceOrientation {
        case .LandscapeLeft:
            frame.size.width = self.view.frame.size.height
            frame.size.height = self.view.frame.size.width
            break
        case .LandscapeRight:
            frame.size.width = self.view.frame.size.height
            frame.size.height = self.view.frame.size.width

            break
        default:
            break
        }
        
        self.avplayerlayer?.frame  = frame
    }

    @available(iOS 8, *)
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var frame  = CGRectZero
        frame.size = size
         self.avplayerlayer!.frame = frame
    }
  
}