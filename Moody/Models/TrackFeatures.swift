//
//  TrackFeatures.swift
//  Moody
//
//  Created by Диас Сайынов on 03.08.2024.
//

import Foundation

struct TrackFeatures: Codable {
    let acousticness: Double
    let danceability: Double
    let energy: Double
    let instrumentalness: Double
    let liveness: Double
    let loudness: Double
    let speechiness: Double
    let tempo: Double
    let time_signature: Int
    let valence: Double
}
