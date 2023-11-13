//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Foundation
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String) -> String {
        let bundle = Bundle(for: FeedViewController.self)
        let key = key
        let localized = bundle.localizedString(forKey: key, value: "Feed Title", table: "Feed")
        return localized
    }
}
