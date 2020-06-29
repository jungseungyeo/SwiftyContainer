//
//  ViewController.swift
//  ExampleSwiftyContainer
//
//  Created by linsaeng on 2020/06/29.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import UIKit
import SwiftyContainer

class ViewController: UIViewController {
    
    lazy var container: SwiftyContainerInteractorable = {
        
        struct Component: SwiftyComponentable {
            var leftMarginOffset: CGFloat { 10 }
            var rightMarginOffset: CGFloat { -10 }
            var bottomMarginOFfset: CGFloat { 10 }
        }
        
        let component = Component()
        
        let composition = SwiftyCompositionContainer.resolve(parentsView: view,
                                                             animationView: ContainerView.loadFromNib(),
                                                             component: component)
        
        let container = SwiftyContainerBuilder(dependency: composition).create()
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.error = { [weak self] error in
            guard let self = self else { return }
            self.errorHandler(error)
        }
    }
    
    @IBAction func show(_ sender: Any) {
        
        container.showDidAppear = {
            print("showDidAppear")
        }
        
        container.show()
    }
    
    @IBAction func hide(_ sender: Any) {
        
        container.hideDidAppear = {
            print("hideDidAppear")
        }
        
        container.hide()
    }
    
    private func errorHandler(_ error: Error) {
        guard let swiftyContainerError = error as? SwiftyContainerInteractorError else {
            return
        }
        
        switch swiftyContainerError {
        case .alreadyShow:
            print("alreadyShow")
        case .alreadyHide:
            print("alreadyHide")
        case .duringAnimation:
            print("duringAnimation")
        case .unknown:
            print("unknown")
        }
    }
    
}

