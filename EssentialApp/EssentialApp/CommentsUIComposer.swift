//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/25/23.
//
 
import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
    private init() {}
    
    typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentViewAdapter>
    
    public static func commentsComposeWith(
        commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>)
    -> ListViewController {
            
        let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
        
        let commentsControllers = makeCommentViewController(title: ImageCommentsPresenter.title)
        commentsControllers.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentViewAdapter(controller: commentsControllers),
            loadingView: WeakRefVirtualProxy(commentsControllers),
            errorView: WeakRefVirtualProxy(commentsControllers),
            mapper: { ImageCommentsPresenter.map($0) })
        
        return commentsControllers
    }
    
    private static func makeCommentViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let commentsViewController = storyboard.instantiateInitialViewController() as! ListViewController
        commentsViewController.title = title
        return commentsViewController
    }
}

final class CommentViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController?) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
