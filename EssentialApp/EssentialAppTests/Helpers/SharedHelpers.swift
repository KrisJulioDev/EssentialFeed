//
//  SharedHelpers.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/16/23.
//

import EssentialFeed

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
