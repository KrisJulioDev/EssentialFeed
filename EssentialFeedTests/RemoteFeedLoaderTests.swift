//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/4/23.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
 
    func test_init_doesNotRequestDataOnInit() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load { capturedError.append($0) }
                
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let statusCodes = [199, 201, 230, 250, 280, 299].enumerated()
        statusCodes.forEach { (index, code) in
            var capturedError = [RemoteFeedLoader.Error]()
            sut.load { capturedError.append($0) }
            
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedError, [.invalidData])
        }
    }
     
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://any-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
                
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            
            messages[index].completion(nil, nil)
        }
    }
}
