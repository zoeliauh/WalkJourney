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
}
