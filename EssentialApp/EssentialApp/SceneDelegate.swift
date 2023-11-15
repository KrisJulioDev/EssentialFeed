//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/15/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let feedLoader = RemoteFeedLoader(url: url, client: client)
        
//        let feedViewController = FeedUIComposer.feedComposeWith(feedLoader, imageLoader: <#T##FeedImageDataLoader#>)
    }
}
