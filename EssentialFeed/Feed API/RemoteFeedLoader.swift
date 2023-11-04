//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/4/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load(completion: @escaping ((Error) -> Void)) {
        client.get(from: url) { error, response in
            if error != nil {
                completion(.connectivity)
            } else {
                completion(.invalidData)
            }
        }
    }
}
