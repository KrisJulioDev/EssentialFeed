//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/27/23.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(String)
    
    public func with(_ url: URL) -> URL {
        switch self {
        case let .get(feedImageID):
            URL(string: "\(url.absoluteString)/v1/image/\(feedImageID)/comments")!
        }
    }
}
