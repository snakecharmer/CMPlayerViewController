//
//  ViewController.swift
//  CMPlayerViewController
//
//  Created by Célian MOUTAFIS on 09/03/2016.
//  Copyright © 2016 mouce. All rights reserved.
//

import UIKit
import AVFoundation
import CMPlayerViewController

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


