//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/6/23.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCacheFeed(completion: @escaping (DeletionCompletion))
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
