//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/6/23.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)
 
public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
