//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/13/23.
//


import UIKit
import EssentialFeediOS

extension FeedImageCell {
	func simulateRetryAction() {
		feedImageRetryButton.simulateTap()
	}
	
	var isShowingLocation: Bool {
		return !locationContainer.isHidden
	}
	
	var isShowingImageLoadingIndicator: Bool {
		return feedImageContainer.isShimmering
	}
	
	var isShowingRetryAction: Bool {
		return !feedImageRetryButton.isHidden
	}
	
	var locationText: String? {
		return locationLabel.text
	}
	
	var descriptionText: String? {
		return descriptionLabel.text
	}
	
	var renderedImage: Data? {
		return feedImageView.image?.pngData()
	}
}
