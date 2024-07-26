//
//  TopTracksResponse.swift
//  Moody
//
//  Created by Диас Сайынов on 09.07.2024.
//

// TopTracksResponse.swift

import Foundation

struct RecommendedTracks: Codable {
    let tracks: [AudioTrack]
}

struct AudioTrack: Codable {
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let name: String
    let popularity: Int
}

struct TopTracksResponse: Codable {
    let items: [Track]
}

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_ids: ExternalIDs
    let external_urls: [String: String]
    let href: String
    let id: String
    let is_local: Bool
    let name: String
    let popularity: Int
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
}

struct Album: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let release_date: String
    let release_date_precision: String
    let total_tracks: Int
    let type: String
    let uri: String
}

struct Artist: Codable {
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}

struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}

struct ExternalIDs: Codable {
    let isrc: String
}


