//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/15/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public var message: String?
    
    static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
