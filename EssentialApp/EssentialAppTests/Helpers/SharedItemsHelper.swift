//
//  SharedItemsHelper.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/15/23.
//

import Foundation
import EssentialFeed

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
 
func anyData() -> Data {
   return Data("any data".utf8)
}


private class DummyView: ResourceView {
    func display(_ viewModel: Any) { }
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}
