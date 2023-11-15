//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/15/23.
//

import XCTest
import EssentialFeed

public final class RemoteImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    let primaryLoader: FeedImageDataLoader
    let fallbackLoader: FeedImageDataLoader
    
    init(primaryLoader: FeedImageDataLoader, fallbackLoader: FeedImageDataLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void)
    -> FeedImageDataLoaderTask {
        primaryLoader.loadImageData(from: url) { result in
            completion(result)
        }
    }
}

final class FeedImageDataLoaderWithFallbackComposite: XCTestCase {
    
    func test_load_deliversPrimaryImageDataForPrimaryLoadSuccess() {
        let primaryData = anyData()
        let fallbackData = Data("any-random-data".utf8)
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(fallbackData))
        
        let exp = expectation(description: "Waiting for remote load completion")
        _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, primaryData)
                
            case let .failure(error):
                XCTFail("Expecting success, got \(error)")
                
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(primaryResult: FeedImageDataLoader.Result,
                         fallbackResult: FeedImageDataLoader.Result,
                         file: StaticString = #file,
                         line: UInt = #line) -> FeedImageDataLoader {
        
        let sut = RemoteImageDataLoaderWithFallbackComposite(
            primaryLoader: FeedImageDataLoaderStub(result: primaryResult),
            fallbackLoader: FeedImageDataLoaderStub(result: fallbackResult))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private class FeedImageDataLoaderStub: FeedImageDataLoader {
        let result: FeedImageDataLoader.Result
        var task: FeedImageDataLoaderTask?
        
        init(result: FeedImageDataLoader.Result) {
            self.result = result
            
        }
        struct FeedImageDataLoaderTaskSpy: FeedImageDataLoaderTask {
            func cancel() {
                
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            completion(result)
            return FeedImageDataLoaderTaskSpy()
        }
    }
    
   func anyData() -> Data {
       return Data("any data".utf8)
   }
}
