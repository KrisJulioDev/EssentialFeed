//
//  URLHTTPResponse+Helper.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/15/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
