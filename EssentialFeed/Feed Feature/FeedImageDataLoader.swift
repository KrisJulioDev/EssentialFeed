//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/16/23.
//

import Foundation

public protocol FeedImageDataLoader { 
    func loadImageData(from url: URL) throws -> Data
}
