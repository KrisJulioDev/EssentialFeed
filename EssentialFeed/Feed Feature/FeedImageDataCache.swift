//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/16/23.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
