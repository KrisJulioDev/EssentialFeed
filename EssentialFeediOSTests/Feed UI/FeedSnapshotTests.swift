//
//  FeedSnapshotTests.swift
//
//  Created by Khristoffer Julio on 11/17/23.
//

import XCTest
@testable import EssentialFeed
import EssentialFeediOS

final class FeedSnapshotTests: XCTestCase {
    
    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_FEED_dark")
    }

    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT_dark")

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_dark_extraExtraExtraLarge")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark")

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark_extraExtraExtraLarge")
    }
    
    func test_feedWithLoadMoreIndicator() {
        let sut = makeSUT()
        
        sut.display(feedWithLoadMoreIndicator())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_LOAD_MORE_INDICATOR_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_LOAD_MORE_INDICATOR_dark")
    }
    
    func test_feedWithLoadMoreError() {
        let sut = makeSUT()
        
        sut.display(feedWithLoadMoreError())
        
        record(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_LOAD_MORE_ERROR_light")
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_LOAD_MORE_ERROR_dark")
        
        record(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_LOAD_MORE_ERROR_light_extraExtraExtraLarge")
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_LOAD_MORE_ERROR_dark_dark_extraExtraExtraLarge")

    }
    
    // MARK: - Helpers
    
    func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [CellController] { [] }
    
    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            )
        ]
    }
    
    func assert(_ snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        guard let data = snapshot.pngData() else {
            return XCTFail("Cannot generate data from snapshot image")
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshot")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            try data.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to create directory and save the snapshot.")
        }
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(
                description: nil,
                location: "Cannon Street, London",
                image: nil
            ),
            ImageStub(
                description: nil,
                location: "Brighton Seafront",
                image: nil
            )
        ]
    }
    
    private func feedWithLoadMoreIndicator() -> [CellController] {
        let stub = feedWithContent().last!
        let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
        stub.controller = cellController
        
        let loadMore = LoadMoreCellController(callback: { })
        loadMore.display(ResourceLoadingViewModel(isLoading: true))
            
        return [
            CellController(id: UUID(), cellController),
            CellController(id: UUID(), loadMore),
        ]
    }
    
    private func feedWithLoadMoreError() -> [CellController] {
        let stub = feedWithFailedImageLoading().last!
        let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
        stub.controller = cellController
        
        let loadMore = LoadMoreCellController(callback: { })
        loadMore.display(ResourceErrorViewModel(message: "This is a multiline error message"))
            
        return [
            CellController(id: UUID(), cellController),
            CellController(id: UUID(), loadMore),
        ]
    }
}

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {  })
            stub.controller = cellController
            return CellController(id: UUID(), cellController)
        }
        
        display(cells)
    }
}

extension ListViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}

class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel
    let image: UIImage?
    weak var controller: FeedImageCellController?

    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location)
        
        self.image = image
    }
    
    func didRequestImage() {
        controller?.display(.init(isLoading: true))
        
        if let image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: .none))
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }
    
    func didCancelImageRequest() {}
}
