//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/15/23.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteFeedImageLoader = RemoteFeedImageDataLoader(client: client)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appending(path: "feed-store.sqlite")
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader =  LocalFeedImageDataLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedComposeWith(
            feedLoader: RemoteLoaderWithLocalFallbackComposite(
                primaryLoader: remoteFeedLoader,
                fallbackLoader: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primaryLoader: remoteFeedImageLoader,
                fallbackLoader: localImageLoader)
        )
        
        window?.rootViewController = feedViewController
    }
}
