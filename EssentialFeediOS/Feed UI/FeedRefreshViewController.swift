//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/10/23.
//

import UIKit

final class RefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadedView()
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
     
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadedView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
