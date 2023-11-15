//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Foundation
import EssentialFeed

extension FeedUIIntegrationTests {
    func localized(_ key: String) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let key = key
        let localized = bundle.localizedString(forKey: key, value: "Feed Title", table: "Feed")
        return localized
    }
}
