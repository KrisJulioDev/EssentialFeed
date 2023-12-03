//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/17/23.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
} 
