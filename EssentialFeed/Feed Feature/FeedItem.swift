//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/4/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let name: String?
    let location: String?
    let image: URL
}
