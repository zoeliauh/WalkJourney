//
//  JGProgressHUDWrapper.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/14.
//

import Foundation
import JGProgressHUD
import UIKit

class Toast {

    static let shared = Toast()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    var view = UIViewController.getLastPresentedViewController()?.view

    static func showSuccess(text: String) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showLoading(text: String) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showLoading(text: text)
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = text

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())
    }

    static func showFailure(text: String) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())

        shared.hud.dismiss(afterDelay: 1.5)
    }
}
