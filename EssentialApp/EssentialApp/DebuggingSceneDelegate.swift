//
//  DebuggingSceneDelegate.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/17/23.
//

#if DEBUG
import UIKit
import EssentialFeed

class DebuggingSceneDelegate: SceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
          
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    override func makeRemoteClient() -> HTTPClient {
        if let connectivity = UserDefaults.standard.string(forKey: "connectivity") {
            return DebuggingHTTPClient(connectivity: connectivity)
        }
        return super.makeRemoteClient()
    }
    
}


private class DebuggingHTTPClient: HTTPClient {
    let connectivity: String
    
    init(connectivity: String) {
        self.connectivity = connectivity
    }
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        
        switch connectivity {
        case "online":
            completion(.success(makeSuccesfulResponse(from: url)))
        default:
            completion(.failure(NSError(domain: "offline", code: 0)))
        }
        return Task()
    }
    
    private func makeSuccesfulResponse(from url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = makeData(for: url)
        return (data, response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()
        default:
            return makeFeedData()
        }
    }
    
    private func makeImageData() -> Data {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 1, height: 1))
        return renderer.pngData { context in
            UIColor.red.setFill()
            context.fill(renderer.format.bounds)
        }
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"]
        ]])
    }
    
}
#endif
