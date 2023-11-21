//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/20/23.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
 
