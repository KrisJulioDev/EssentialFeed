//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/21/23.
//

import XCTest
import EssentialFeed

final class LoadResourcePresenterTests: XCTestCase {
    
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
    
    func test_loadFinish_hideLoadingAndShowFeed() {
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().models
        
        sut.didFinishLoadingFeed(with: feed)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(feed: feed)
        ])
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(feedView: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    func localized(_ key: String) -> String {
        let bundle = Bundle(for: LoadResourcePresenter.self)
        let key = key
        let localized = bundle.localizedString(forKey: key, value: "", table: "Feed")
        return localized
    }
    
    private final class ViewSpy: FeedView, FeedErrorView, FeedLoadingView {
        
        enum Messages: Hashable {
            case display(feed: [FeedImage])
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }
        
        private(set) var messages = Set<Messages>()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
         
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
    }
}
