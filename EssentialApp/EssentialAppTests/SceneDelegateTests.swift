//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/17/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

final class SceneDelegateTests: XCTestCase {
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        sut.configureWindow()
        
        let navigationController = sut.window?.rootViewController as? UINavigationController
        let topController = navigationController?.topViewController
        
        XCTAssertNotNil(navigationController, "Expecting there's a rootViewController")
        XCTAssertTrue(topController is FeedViewController, "Expecting there's a rootViewController")
    }
}
