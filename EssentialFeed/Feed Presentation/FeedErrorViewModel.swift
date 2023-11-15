//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/15/23.
//

import Foundation

public struct FeedErrorViewModel {
    public var message: String?
    
    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
