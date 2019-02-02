//
//  AlertController.swift
//  AutoSelfie
//
//  Created by ShuichiNagao on 2019/02/02.
//  Copyright © 2019 Shuichi Nagao. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    private lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ClearViewController()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        return window
    }()
    
    func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        guard let rootVC = alertWindow.rootViewController else { return }
        alertWindow.makeKeyAndVisible()
        rootVC.present(self, animated: flag, completion: completion)
    }
}

private class ClearViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}
