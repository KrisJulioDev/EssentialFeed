//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/9/23.
//

import UIKit

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView {
    var delegate: FeedViewControllerDelegate?
    
    private var imageLoader: FeedImageDataLoader?
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
     
	public override func viewDidLoad() {
		super.viewDidLoad()
        
		tableView.prefetchDataSource = self
        refresh()
	}
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(for: indexPath).view()
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
    
    func cellController(for indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
	
    private func cancelControllerLoad(forRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoad()
    }
}
