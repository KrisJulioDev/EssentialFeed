//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Khristoffer Julio on 11/9/23.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
	private var refreshController: RefreshViewController?
	private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]() {
        didSet { tableView.reloadData() }
    }

    private var tasks = [IndexPath: FeedImageDataLoaderTask]()
    private var cellControllers = [IndexPath: FeedImageCellController]()

	public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
		self.init()
		self.refreshController = RefreshViewController(feedLoader: feedLoader)
		self.imageLoader = imageLoader
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
        
		tableView.prefetchDataSource = self
        refreshController?.refresh()
	}
	
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(for: indexPath).view()
	}
	
	public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
	}
	
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
            cellController(for: indexPath).prefetch()
		}
	}
	
	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { cellControllers[$0] = nil }
	}
    
    func cellController(for indexPath: IndexPath) -> FeedImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader)
        cellControllers[indexPath] = cellController
        return cellController
    }
	
	private func cancelTask(forRowAt indexPath: IndexPath) {
		cellControllers[indexPath] = nil
	}
}
