//
//  UserProfile.swift
//  Moody
//
//  Created by Диас Сайынов on 05.07.2024.
//

import Foundation

struct UserProfile: Codable{
    let country: String
    let display_name: String
    let email: String?
    //let followers: [String : Codable?]
    let id: String
    let product: String
    let images: [APIImage]
}
