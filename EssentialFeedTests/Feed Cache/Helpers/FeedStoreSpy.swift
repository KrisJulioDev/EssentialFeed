//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/6/23.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    private(set) var receivedMessage = [ReceiveMessage]()
    
    enum ReceiveMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
    }
     
    private(set) var deletionCompletions = [DeletionCompletion]()
    private(set) var insertionCompletions = [InsertionCompletion]()
    
    func deleteCachedFeed(completion: @escaping (DeletionCompletion)) {
        deletionCompletions.append(completion)
        receivedMessage.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping (InsertionCompletion)) {
        insertionCompletions.append(completion)
        receivedMessage.append(.insert(items, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
}
