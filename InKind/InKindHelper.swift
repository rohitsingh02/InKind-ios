//
//  File.swift
//  InKind
//
//  Created by Rohit Singh on 01/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class InKindHelper : NSObject {

    static func showErrorMessageAboveNav(title : String?, body : String?){
        
        let view = MessageView.viewFromNib(layout: .MessageView)
        //view.configureTheme(.error)
        
        let backgroundColor = UIColor.init(hex: 0xFF6666, alpha: 1.0)
        let foregroundColor = UIColor.white
        
        view.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: { _ in
            SwiftMessages.hide()
        })
        view.button?.contentEdgeInsets = UIEdgeInsetsMake(-5.0, -5.0, -5.0, -5.0)
        view.button?.layer.borderWidth = 0.0;
        view.button?.setImage(UIImage(named: "errorIcon"), for: .normal)
        // Show the message.
        
        view.tapHandler = { _ in SwiftMessages.hide()
        }
        
        SwiftMessages.show(view: view)
    }
    
    static func showErrorMessageBelowNav(title : String?, body : String?){
        
        var config = SwiftMessages.Config()
        
        let view = MessageView.viewFromNib(layout: .MessageView)
        
        let backgroundColor = UIColor.init(hex: 0xFF6666, alpha: 1.0)
        let foregroundColor = UIColor.white
        
        view.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: { _ in
            SwiftMessages.hide()
        })
        view.button?.contentEdgeInsets = UIEdgeInsetsMake(-5.0, -5.0, -5.0, -5.0)
        view.button?.layer.borderWidth = 0.0;
        view.button?.setImage(UIImage(named: "errorIcon"), for: .normal)
        
        view.tapHandler = { _ in SwiftMessages.hide()
        }
        
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: view)
    }
    
    
    
    static func showSuccessMessage(title : String?, body : String?){
        
        var config = SwiftMessages.Config()
        
        let view = MessageView.viewFromNib(layout: .MessageView)
        
        let backgroundColor = UIColor.init(hex: 0x016FB9, alpha: 1.0)
        let foregroundColor = UIColor.white
        
        view.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        
        view.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: { _ in
            SwiftMessages.hide()
        })
        view.button?.contentEdgeInsets = UIEdgeInsetsMake(-5.0, -5.0, -5.0, -5.0)
        view.button?.layer.borderWidth = 0.0;
        view.button?.setImage(UIImage(named: "errorIcon"), for: .normal)
        view.tapHandler = { _ in SwiftMessages.hide()
        }
        
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: view)
    }
    
    
    static func showNoInternetMessage(){
        
        let view = MessageView.viewFromNib(layout: .MessageView)
        
        let backgroundColor = UIColor.init(hex: 0x5D737E, alpha: 1.0)
        let foregroundColor = UIColor.white
        
        view.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        view.configureContent(title: nil, body: "No Internet Connection", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "DISMISS", buttonTapHandler: { _ in
            SwiftMessages.hide()
        })
        
        view.button?.backgroundColor = backgroundColor
        view.button?.tintColor = foregroundColor
        view.button?.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        view.button?.layer.borderWidth = 0.0;
        SwiftMessages.show(view: view)
    }

    
    func showProgressIndicator(loadingView: UIView,actInd: UIActivityIndicatorView, view: UIView )
    {
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center =  view.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        view.addSubview(loadingView)
        actInd.startAnimating()
        
    }

    func initErrorPage(imageName:String,labelText: String, view : UIView,containerView: UIView, isCentered : Bool){
        
        containerView.frame = CGRect(x: 0, y: view.frame.size.height / 2 - 125, width: view.frame.size.width, height: 250)
        let imageView = UIImageView(image:UIImage(named: imageName))
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = CGPoint(x: containerView.frame.size.width / 2 , y: containerView.frame.size.height / 2 )
        
        let noDataLabel = UILabel()
        noDataLabel.frame = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 60)
        noDataLabel.center = CGPoint(x: containerView.frame.size.width / 2 , y: containerView.frame.size.height)
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        noDataLabel.font = UIFont.init(name: "Futura-Medium", size: 14)
        noDataLabel.text = labelText
        containerView.isHidden = true
        containerView.addSubview(imageView)
        containerView.addSubview(noDataLabel)
        view.addSubview(containerView)
        
        if isCentered{
            
            containerView.center = CGPoint(x: containerView.frame.size.width / 2 , y: containerView.frame.size.height - 44)
        }
        
    }
    
    
    
}
