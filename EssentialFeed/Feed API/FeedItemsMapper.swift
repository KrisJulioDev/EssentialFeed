//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/5/23.
//

import Foundation

internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            items.map { $0.item }
        }
    }
    
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}

/**
 private class URLProtocolStub: URLProtocol {
     private static var stubs = [URL: Stub]()
     
     private struct Stub {
         let data: Data?
         let response: URLResponse?
         let error: Error?
     }
     
     static func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) {
         stubs[url] = Stub(data: data, response: response, error: error)
     }
 
     static func startInterceptingRequests() {
         URLProtocol.registerClass(URLProtocolStub.self)
     }
     
     static func stopInterceptingRequests() {
         URLProtocol.unregisterClass(URLProtocolStub.self)
         stubs = [:]
     }
     
     override class func canInit(with request: URLRequest) -> Bool {
         guard let url = request.url else { return false }
         
         return URLProtocolStub.stubs[url] != nil
     }
     
     override class func canonicalRequest(for request: URLRequest) -> URLRequest {
         return request
     }
  
     override func startLoading() {
         guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }
         
         if let data = stub.data {
             client?.urlProtocol(self, didLoad: data)
         }

         if let response = stub.response {
             client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
         }
         
         if let error = stub.error {
             client?.urlProtocol(self, didFailWithError: error)
         }
         
         client?.urlProtocolDidFinishLoading(self)
     }
     
     override func stopLoading() {}
 }
 
 */
