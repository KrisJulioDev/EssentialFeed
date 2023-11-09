//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/9/23.
//

import XCTest
import UIKit

class FeedViewController: UIViewController {
    var loader: FeedViewControllerTests.LoaderSpy?
    
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load()
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesntLoadFeedInCreation() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.callCount, 0)
    }
    
    class LoaderSpy {
        var callCount = 0
        
        func load() {
            callCount += 1
        }
    }
}
