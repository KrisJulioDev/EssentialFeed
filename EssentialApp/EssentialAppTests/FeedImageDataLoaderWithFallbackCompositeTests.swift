//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/15/23.
//

import XCTest
import EssentialApp
import EssentialFeed

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageDataForPrimaryLoadSuccess() {
        let primaryData = anyData()
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(Data("any-random-data".utf8)))
        
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
    
    func test_load_deliversFallbackImageDataWhenPrimaryLoadFails() {
        let fallbackData = Data("any-random-data".utf8)
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackData))
        
        expect(sut, toCompleteWith: .success(fallbackData))
    }
    
    func test_load_deliversErrorResultOnPrimaryAndFallbackFailureResult() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func expect(_ sut: FeedImageDataLoader, 
                toCompleteWith expectedResult: FeedImageDataLoader.Result,
                file: StaticString = #file,
                line: UInt = #line) {
        
        let exp = expectation(description: "Waiting for remote load completion")
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)

            default:
                XCTFail("Unexpected result given: \(receivedResult), expecting \(expectedResult)")
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
        
        let primaryLoader = FeedImageDataLoaderStub(result: primaryResult)
        let fallbackLoader = FeedImageDataLoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallbackComposite(primaryLoader: primaryLoader,
                                                             fallbackLoader: fallbackLoader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        
        return sut
    }
    
    private class FeedImageDataLoaderStub: FeedImageDataLoader {
        let result: FeedImageDataLoader.Result
        var task: FeedImageDataLoaderTask?
        
        init(result: FeedImageDataLoader.Result) {
            self.result = result
            
        }
        
        struct FeedImageDataLoaderTaskSpy: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            completion(result)
            return FeedImageDataLoaderTaskSpy()
        }
    }
}
