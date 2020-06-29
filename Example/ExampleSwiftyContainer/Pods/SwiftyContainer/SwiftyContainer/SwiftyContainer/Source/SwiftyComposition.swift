//
//  SwiftyComposition.swift
//  SwiftyContainer
//
//  Created by linsaeng on 2020/06/28.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import UIKit

// MARK: - Composition

public protocol SwiftyComponentable {
    var leftMarginOffset: CGFloat { get }
    var rightMarginOffset: CGFloat { get }
    var bottomMarginOFfset: CGFloat { get }
}

public struct SwiftyDefaultComponent: SwiftyComponentable {
    public var leftMarginOffset: CGFloat { 10 }
    public var rightMarginOffset: CGFloat { -10 }
    public var bottomMarginOFfset: CGFloat { 10 }
}

public protocol SwiftyDependency {
    var parentsView: UIView { get }
    var animationView: UIView { get }
    var component: SwiftyComponentable { get }
}

private class SwiftyContainerDependency: SwiftyDependency {
    
    let parentsView: UIView
    let animationView: UIView
    let component: SwiftyComponentable
    
    init(parentsView: UIView, animationView: UIView, component: SwiftyComponentable) {
        self.parentsView = parentsView
        self.animationView = animationView
        self.component = component
    }
}

public enum SwiftyCompositionContainer {
    public static func resolve (
        parentsView: UIView,
        animationView: UIView,
        component: SwiftyComponentable
    ) -> SwiftyDependency {
        return SwiftyContainerDependency (
            parentsView: parentsView,
            animationView: animationView,
            component: component
        )
    }
}
