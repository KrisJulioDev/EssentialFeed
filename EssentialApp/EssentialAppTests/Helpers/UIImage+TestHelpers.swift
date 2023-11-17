//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/13/23.
//


import UIKit

extension UIImage {
	static func make(withColor color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 1, height: 1))
        return renderer.image { context in
            UIColor.red.setFill()
        }
	}
}
