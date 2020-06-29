//
//  SwiftyInteractor.swift
//  SwiftyContainer
//
//  Created by linsaeng on 2020/06/28.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import Foundation

// MARK: - Interactor

public protocol SwiftyContainerInteractorable: class {
    func show()
    func hide()
    
    var showDidAppear: (() -> Void)? { set get }
    var hideDidAppear: (() -> Void)? { set get }
    var error: ((Error) -> Void)? { set get }
}

public enum SwiftyContainerInteractorError: Int, Swift.Error, CustomStringConvertible {
    
    case alreadyShow = -996
    case alreadyHide = -997
    case duringAnimation = -998
    case unknown = -999
    
    public var description: String {
        switch self {
        case .alreadyShow:
            return "The view is already showing"
        case .alreadyHide:
            return "The view is already hiding"
        case .duringAnimation:
            return "The view is being animated"
        case .unknown:
            return "Unknown error"
        }
    }
}

class SwiftyContainerInteractor: SwiftyContainerInteractorable {
    
    private let component: SwiftyComponentable
    private let container: SwiftyContainerable
    
    public private(set) var isShow: Bool = false
    private var isAnimation: Bool = false
    
    var showDidAppear: (() -> Void)?
    var hideDidAppear: (() -> Void)?
    var error: ((Error) -> Void)?
    
    init(component: SwiftyComponentable, container: SwiftyContainerable) {
        self.component = component
        self.container = container
        
        container.configure(
            leftOffset: component.leftMarginOffset,
            rightOffset: component.rightMarginOffset
        )
    }
    
    func show() {
        do {
            guard isAnimation == false else {
                throw SwiftyContainerInteractorError.duringAnimation
            }
            
            guard isShow == false else  {
                throw SwiftyContainerInteractorError.alreadyShow
            }
            
            isShow = true
            isAnimation = true
            container.show(bottomOffset: component.bottomMarginOFfset,
                           completion: { [weak self] in
                            guard let self = self else { return }
                            self.isAnimation = false
                            self.showDidAppear?()
            })
        } catch let error as SwiftyContainerInteractorError {
            #if DEBUG
                debugPrint(error.localizedDescription)
            #endif
            self.error?(error)
        } catch {
            #if DEBUG
                debugPrint(error.localizedDescription)
            #endif
            self.error?(SwiftyContainerInteractorError.unknown)
        }
    }
    
    func hide() {
        do {
            guard isAnimation == false else {
                throw SwiftyContainerInteractorError.duringAnimation
            }
            
            guard isShow == true else {
                throw SwiftyContainerInteractorError.alreadyHide
            }
            
            isShow = false
            isAnimation = true
            
            container.hide(bottomOffset: component.bottomMarginOFfset,
                           completion: { [weak self] in
                            guard let self = self else { return }
                            self.isAnimation = false
                            self.hideDidAppear?()
            })
            
        } catch let error as SwiftyContainerInteractorError {
            #if DEBUG
                debugPrint(error.localizedDescription)
            #endif
            self.error?(error)
        } catch {
            #if DEBUG
                debugPrint(error.localizedDescription)
            #endif
            self.error?(SwiftyContainerInteractorError.unknown)
        }
    }
}
