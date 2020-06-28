//
//  SwiftyContainerTests.swift
//  SwiftyContainerTests
//
//  Created by linsaeng on 2020/06/28.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import XCTest
@testable import SwiftyContainer

class SwiftyContainerTests: XCTestCase {
    
    private var containerInteractor: SwiftyContainerInteractor!
    
    struct Const {
        static let parentsView: UIView = UIView(frame: .zero)
        static let animationView: UIView = UIView(frame: .zero)
    }
    
    override func setUp() {
        super.setUp()
        
        // give
        let composition = SwiftyCompositionContainer.resolve(
            parentsView: Const.parentsView,
            animationView: Const.animationView
        )
        
        containerInteractor = SwiftyContainerBuilder(dependency: composition).create() as? SwiftyContainerInteractor
        
    }
    
    func test_Animation_Show() {
        // give - setup
        
        // when
        containerInteractor.show()
        
        // then
        XCTAssertEqual(containerInteractor.isShow, true)
    }
    
    func test_Ainmation_Hide() {
        
        // give
        let didFinish = expectation(description: #function)
        
        // when
        containerInteractor.showDidAppear = { [weak self] in
            guard let self = self else { return }
            self.containerInteractor.hide()
            didFinish.fulfill()
        }
        
        containerInteractor.show()
        
        wait(for: [didFinish], timeout: 5.0)
        
        // then
        XCTAssertEqual(containerInteractor.isShow, false)
    }
    
    func test_Animation_ShowDidAppear() {
        
        // give
        let didFinish = expectation(description: #function)
        
        var result: Bool = false
        
        // when
        containerInteractor.showDidAppear = { [weak self] in
            guard let self = self else { return }
            result = self.containerInteractor.isShow
            didFinish.fulfill()
        }
        
        containerInteractor.show()
        
        wait(for: [didFinish], timeout: 5.0)
        
        // then
        XCTAssertEqual(result, true)
    }
    
    func test_Animation_HideDIdAppear() {
        
        // give
        let didFinish = expectation(description: #function)
        var result = true
        
        // when
        containerInteractor.showDidAppear = { [weak self] in
            guard let self = self else { return }
            result = true
            self.containerInteractor.hide()
        }
        
        containerInteractor.showDidAppear = {
            result = false
            didFinish.fulfill()
        }
        
        containerInteractor.show()
        
        wait(for: [didFinish], timeout: 5.0)
        
        // then
        XCTAssertEqual(result, false)
        
    }
    
    func test_ErrorMessage_alreadShow() {
        
        // give
        let didFinish = expectation(description: #function)
        var containerError: SwiftyContainerInteractorError = .unknown
        
        // when
        containerInteractor.error = { error in
            containerError = error as? SwiftyContainerInteractorError ?? .unknown
            didFinish.fulfill()
        }
        
        containerInteractor.showDidAppear = {
            self.containerInteractor.show()
        }
        
        containerInteractor.show()
        
        wait(for: [didFinish], timeout: 5.0)
        
        // then
        XCTAssertEqual(containerInteractor.isShow, true)
        XCTAssertEqual(containerError, .alreadyShow)
    }
    
    func test_ErrorMessage_alreadyHide() {
        
        // give
        let didFInish = expectation(description: #function)
        var containerError: SwiftyContainerInteractorError = .unknown
        
        // when
        containerInteractor.error = { error in
            containerError = error as? SwiftyContainerInteractorError ?? .unknown
            didFInish.fulfill()
        }
        
        containerInteractor.hide()
        
        wait(for: [didFInish], timeout: 5.0)
        
        // then
        XCTAssertEqual(containerInteractor.isShow, false)
        XCTAssertEqual(containerError, .alreadyHide)
    }
    
    func test_ErrorMessage_duringAnimation() {
        
        // give
        let didFinish = expectation(description: #function)
        var containerError: SwiftyContainerInteractorError = .unknown
        
        // when
        containerInteractor.error = { error in
            containerError = error as? SwiftyContainerInteractorError ?? .unknown
            didFinish.fulfill()
        }
        
        containerInteractor.show()
        containerInteractor.show()
        
        wait(for: [didFinish], timeout: 5.0)
        
        // then
        XCTAssertEqual(containerError, .duringAnimation)
    }
}
