//
//  ResponseDTO.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation

// MARK: - FlickrPhotoSearchResponse
struct FlickrPhotoSearchResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
