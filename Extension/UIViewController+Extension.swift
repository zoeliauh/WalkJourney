//
//  UIViewController+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/14.
//

import UIKit
extension UIViewController {

    static func getLastPresentedViewController() -> UIViewController? {

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        let window = sceneDelegate?.window

        var presentedViewController = window?.rootViewController

        while presentedViewController?.presentedViewController != nil {

            presentedViewController = presentedViewController?.presentedViewController
        }

        return presentedViewController
    }
    
    static func confirmationAlert(title: String?, message: String?,
                                  preferredStyle: UIAlertController.Style,
                                  actions: [UIAlertAction]) -> UIAlertController {
        
        let alertController = UIAlertController(title: title,
                                      message: message,
                                    preferredStyle: preferredStyle)
        
        for action in actions {
            
            alertController.addAction(action)
        }
        
        if preferredStyle == .actionSheet {
            
            let controller = UIViewController()
            
            if let popoverController = alertController.popoverPresentationController {

                popoverController.sourceView = controller.view
                        popoverController.sourceRect = CGRect(
                            x: controller.view.bounds.midX, y: controller.view.bounds.midY,
                            width: 0, height: 0
                        )
                        popoverController.permittedArrowDirections = []
                    }
        }

        return alertController
    }
}
