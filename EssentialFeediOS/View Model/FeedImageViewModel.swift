//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/11/23.
// 

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
