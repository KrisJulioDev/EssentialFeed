//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/20/23.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
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
        
        expect(sut, toCompleteWith: failure(RemoteImageCommentsLoader.Error.connectivity), when: {
            client.complete(with: NSError(domain: "Test", code: 0))
        })
    }
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let statusCodes = [199, 150, 300, 400, 500].enumerated()
        statusCodes.forEach { (index, code) in
            expect(sut, toCompleteWith: failure(RemoteImageCommentsLoader.Error.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let statusCodes = [200, 201, 250, 280, 299].enumerated()
        
        statusCodes.forEach { (index, code) in
            expect(sut, toCompleteWith: failure(RemoteImageCommentsLoader.Error.invalidData), when: {
                let invalidJSON = Data("invalid json".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }
     
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        let statusCodes = [200, 201, 250, 280, 299].enumerated()
        
        statusCodes.forEach { (index, code) in
            expect(sut, toCompleteWith: .success([])) {
                let emptyListJSON = makeItemsJSON([])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            }
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!)
        
        let items = [item1.model, item2.model]
        let statusCodes = [200, 201, 250, 280, 299].enumerated()
        
        statusCodes.forEach { (index, code) in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemsJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let url = URL(string: "any-url")!
        let client = HTTPClientSpy()
        var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)
        
        var capturedMessage = [RemoteImageCommentsLoader.Result]()
        sut?.load { capturedMessage.append($0) }
        
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertTrue(capturedMessage.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://any-url")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)

        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)

        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].reduce(into: [String: Any]()) { (acc, e) in
            if let value = e.value { acc[e.key] = value }
        }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWith expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }

    class HTTPClientSpy: HTTPClient {
        private struct Task: HTTPClientTask {
            let callback: () -> Void
            func cancel() { callback() }
        }
        
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        private(set) var cancelledURLs = [URL]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }

}
