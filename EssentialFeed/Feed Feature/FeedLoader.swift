//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/4/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping((LoadFeedResult) -> Void))
}
