//
//  CurrentTrack.swift
//  Moody
//
//  Created by Диас Сайынов on 03.08.2024.
//

import Foundation

struct CurrentTrackItem: Codable {
    let id: String
    let name: String
    let album: CurrentTrackAlbum
}

struct CurrentTrackAlbum: Codable {
    let images: [CurrentTrackImages]
}

struct CurrentTrackImages: Codable {
    let url: String
}

struct CurrentTrackResponse: Codable {
    let item: CurrentTrackItem
}
