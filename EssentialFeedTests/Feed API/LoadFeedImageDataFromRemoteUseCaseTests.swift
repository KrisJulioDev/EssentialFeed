//
//  LoadFeedImageDataFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/15/23.
//

import XCTest
import EssentialFeed

final class LoadFeedImageDataFromRemoteUseCaseTests: XCTestCase {
        
    func test_init_doesNotPerformAnyURLRequest() {
        
    }
    
     func test_loadImageDataFromURL_requestsDataFromURL() { }

     func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() { }

     func test_loadImageDataFromURL_deliversConnectivityErrorOnClientError() { }

     func test_loadImageDataFromURL_deliversInvalidDataErrorOnNon200HTTPResponse() { }

     func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() { }

     func test_loadImageDataFromURL_deliversReceivedNonEmptyDataOn200HTTPResponse() { }

     func test_cancelLoadImageDataURLTask_cancelsClientURLRequest() { }

     func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() { }

     func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() { }
    
}
