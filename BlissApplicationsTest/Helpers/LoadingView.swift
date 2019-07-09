//
//  LoadingView.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//


import Foundation
import UIKit

class LoadingView: NSObject {
    
    var overlayView: UIView
    var activityIndicator: UIActivityIndicatorView
    
    override init() {
        overlayView = UIView()
        activityIndicator = UIActivityIndicatorView()
    }
    
    func showOverlayTransparent(over view: UIView) {
        self.showOverlay(over: view)
        overlayView.backgroundColor = #colorLiteral(red: 0.2558659911, green: 0.2558728456, blue: 0.2558691502, alpha: 0.5)
    }
    
    func showOverlay(over view: UIView) {
        if view.tag != 666999 {
            overlayView = UIView()
            overlayView.tag = 666999
            overlayView.frame = view.frame
            overlayView.center = view.center
            overlayView.clipsToBounds = true
            
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.color = #colorLiteral(red: 0, green: 0.6758402586, blue: 0, alpha: 1)
            activityIndicator.center = overlayView.center
            
            overlayView.addSubview(activityIndicator)
            view.addSubview(overlayView)
            
            activityIndicator.startAnimating()
            
        }
    }
    
    func hideOverlayView() {
        activityIndicator.stopAnimating()
        if (overlayView.superview != nil) {
            overlayView.removeFromSuperview()
        }
    }
    
}
