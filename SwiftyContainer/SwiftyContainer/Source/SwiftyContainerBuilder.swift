//
//  SwiftyContainerBuilder.swift
//  SwiftyContainer
//
//  Created by linsaeng on 2020/06/28.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import UIKit

// MARK: - Builder

public protocol SwiftyContainerBuilderable: class {
    func create() -> SwiftyContainerInteractorable
}

public class SwiftyContainerBuilder: SwiftyContainerBuilderable {
    
    private let dependency: SwiftyDependency
    
    public init(dependency: SwiftyDependency) {
        self.dependency = dependency
    }
    
    public func create() -> SwiftyContainerInteractorable {
        return SwiftyContainerInteractor(component: dependency.component,
                                         container: SwiftyContainer(
                                            parentsView: dependency.parentsView,
                                            animationView: dependency.animationView
        ))
    }
}

// MARK: - Container

protocol SwiftyContainerable {
    func configure(leftOffset: CGFloat, rightOffset: CGFloat)
    func show(bottomOffset: CGFloat, completion: @escaping () -> Void)
    func hide(bottomOffset: CGFloat, completion: @escaping () -> Void)
}

private class SwiftyContainer: SwiftyContainerable {
    
    weak var parentsView: UIView?
    weak var animationView: UIView?
    
    var bottomMargin: NSLayoutConstraint?
    
    init(parentsView: UIView, animationView: UIView) {
        self.parentsView = parentsView
        self.animationView = animationView
    }
    
    func configure(leftOffset: CGFloat, rightOffset: CGFloat) {
        guard let parentsView = self.parentsView, let animationView = self.animationView else {
            return
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        parentsView.addSubview(animationView)
        
        animationView.isHidden = true
        
        bottomMargin = .init(item: animationView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: parentsView.safeAreaLayoutGuide,
                             attribute: .bottom,
                             multiplier: 1,
                             constant: parentsView.safeAreaInsets.bottom + animationView.bounds.height)
        
        guard let bottom = bottomMargin else { return }
        
        NSLayoutConstraint.activate([
            animationView.rightAnchor.constraint(equalTo: parentsView.rightAnchor, constant: rightOffset),
            animationView.leftAnchor.constraint(equalTo: parentsView.leftAnchor, constant: leftOffset),
            animationView.heightAnchor.constraint(equalToConstant: animationView.frame.height),
            bottom
        ])
        
        parentsView.setNeedsLayout()
    }
    
    func show(bottomOffset: CGFloat, completion: @escaping () -> Void) {
        
        bottomMargin?.constant = bottomOffset + (self.parentsView?.safeAreaInsets.bottom ?? 0) + (animationView?.bounds.height ?? 0)
        
        parentsView?.layoutIfNeeded()
        
        bottomMargin?.constant = -bottomOffset - (self.parentsView?.safeAreaInsets.bottom ?? 0)
        
        UIView.animate(
            withDuration: 0.5, delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 2,
            options: .allowUserInteraction,
            animations: { [weak self] in
                guard let self = self else { return }
                self.parentsView?.layoutIfNeeded()
                self.animationView?.isHidden = false
            }, completion: { _ in
                completion()
        })
    }
    
    func hide(bottomOffset: CGFloat, completion: @escaping () -> Void) {
        
        bottomMargin?.constant = -bottomOffset - (self.parentsView?.safeAreaInsets.bottom ?? 0)
        
        parentsView?.layoutIfNeeded()
        
        bottomMargin?.constant = bottomOffset + (self.animationView?.bounds.height ?? 0) + (self.parentsView?.safeAreaInsets.bottom ?? 0)
        
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.parentsView?.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.animationView?.isHidden = true
                completion()
        })
    }
    
}
