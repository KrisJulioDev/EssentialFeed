//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/13/23.
//

import XCTest


struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedErrorViewModel {
    var message: String?
    
    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    
    init(errorView: FeedErrorView, loadingView: FeedLoadingView) {
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(.init(isLoading: true))
    }
     
}

final class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendErrorToView() {
        let (_, view) = makeSUT()

        XCTAssert(view.messages.isEmpty, "Expecting no messages upon creation")
    }
    
    func test_load_didStartLoadingAndShowNoErrorOnStartLoad() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none),
                                       .display(isLoading: true)])
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view, loadingView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private final class ViewSpy: FeedErrorView, FeedLoadingView {
        
        enum Messages: Equatable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }
        
        private(set) var messages = [Messages]()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
         
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
    }
}
