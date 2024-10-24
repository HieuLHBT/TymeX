//
//  LoadingOverlay.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import Foundation
import UIKit

//Create system loading interface
public class LoadingOverlay{
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        overlayView.addSubview(activityIndicator)
    }
    
    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
