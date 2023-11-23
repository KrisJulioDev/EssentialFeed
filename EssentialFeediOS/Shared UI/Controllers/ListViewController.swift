//
//  ListViewController.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/9/23.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public protocol CellController {
    func view(in: UITableView) -> UITableViewCell
    func preload()
    func cancelLoad()
}

extension CellController {
    public func preload() {}
    public func cancelLoad() {}
}

final public class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
     
    private var imageLoader: FeedImageDataLoader?
    @IBOutlet private(set) public var errorView: ErrorView?
    
    public var onRefresh: (() -> Void)?
    
    public var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }
     
	public override func viewDidLoad() {
		super.viewDidLoad()
        refresh()
	}
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction func refresh() {
        onRefresh?()
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ cellControllers: [CellController]) {
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(for: indexPath).view(in: tableView)
	}
	
	public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelControllerLoad(forRowAt: indexPath)
    }
	
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
            cellController(for: indexPath).preload()
		}
	}
	
	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { cancelControllerLoad(forRowAt: $0) }
	}
    
    func cellController(for indexPath: IndexPath) -> CellController {
        return tableModel[indexPath.row]
    }
	
    private func cancelControllerLoad(forRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoad()
    }
}
