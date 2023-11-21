//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/4/23.
//

import XCTest
import EssentialFeed

final class FeedItemsMapperTests: XCTestCase {
    
    func test_load_deliversErrorOnNon200HTTPResponse() throws {
        let statusCodes = [199, 201, 230, 250, 280, 299]
        let json = makeItemsJSON([])
        
        try statusCodes.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
     
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let emptyListJSON = makeItemsJSON([])
        let result = try? FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, [])
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!)
        
        let json = makeItemsJSON([item1.json, item2.json])
        let items = [item1.model, item2.model]
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, items)
    }
    
    // MARK: - Helpers
    
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
 
}
