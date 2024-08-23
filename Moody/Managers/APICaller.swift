//
//  APICaller.swift
//  Moody
//
//  Created by Диас Сайынов on 05.07.2024.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
}

enum APIError: Error {
    case dataFailure
    case decodingFailure
}

struct Constants {
    static let baseAPIUrl = "https://api.spotify.com/v1"
    static let baseTopUrl = "https://api.spotify.com/v1/me/top"
}

final class APICaller {
    
    static let shared = APICaller()
    
    private init(){}
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/me"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.dataFailure))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingFailure))
                }
            }
            task.resume()
        }
    }
    
    public func getTopFiveTracks(completion: @escaping (Result<TopTracksResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseTopUrl + "/tracks"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.dataFailure))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TopTracksResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingFailure))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenreResponse, Error>) -> Void)){
        createRequest(
            with: URL(string: Constants.baseAPIUrl + "/recommendations/available-genre-seeds"),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(RecommendedGenreResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    func getRecommendations(
        genres: Set<String>,
        acousticness: Double? = nil,
        danceability: Double? = nil,
        energy: Double? = nil,
        instrumentalness: Double? = nil,
        liveness: Double? = nil,
        loudness: Double? = nil,
        speechiness: Double? = nil,
        tempo: Double? = nil,
        time_signature: Int? = nil,
        valence: Double? = nil,
        completion: @escaping (Result<RecommendedTracks, Error>) -> Void
    ){
        let seeds = genres.joined(separator: ",")
            guard var urlComponents = URLComponents(string: Constants.baseAPIUrl + "/recommendations") else {
                completion(.failure(APIError.dataFailure))
                return
            }
            
            func queryItemValue(for value: Any?) -> String? {
                if let doubleValue = value as? Double {
                    return String(doubleValue)
                } else if let intValue = value as? Int {
                    return String(intValue)
                }
                return nil
            }
            
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "seed_genres", value: seeds))
            
            if let acousticness = acousticness {
                queryItems.append(URLQueryItem(name: "target_acousticness", value: queryItemValue(for: acousticness)))
            }
            if let danceability = danceability {
                queryItems.append(URLQueryItem(name: "target_danceability", value: queryItemValue(for: danceability)))
            }
            if let energy = energy {
                queryItems.append(URLQueryItem(name: "target_energy", value: queryItemValue(for: energy)))
            }
            if let instrumentalness = instrumentalness {
                queryItems.append(URLQueryItem(name: "target_instrumentalness", value: queryItemValue(for: instrumentalness)))
            }
            if let liveness = liveness {
                queryItems.append(URLQueryItem(name: "target_liveness", value: queryItemValue(for: liveness)))
            }
            if let loudness = loudness {
                queryItems.append(URLQueryItem(name: "target_loudness", value: queryItemValue(for: loudness)))
            }
            if let speechiness = speechiness {
                queryItems.append(URLQueryItem(name: "target_speechiness", value: queryItemValue(for: speechiness)))
            }
            if let tempo = tempo {
                queryItems.append(URLQueryItem(name: "target_tempo", value: queryItemValue(for: tempo)))
            }
            if let time_signature = time_signature {
                queryItems.append(URLQueryItem(name: "target_time_signature", value: queryItemValue(for: time_signature)))
            }
            if let valence = valence {
                queryItems.append(URLQueryItem(name: "target_valence", value: queryItemValue(for: valence)))
            }
            
            urlComponents.queryItems = queryItems
                    
            guard let url = urlComponents.url else {
                completion(.failure(APIError.dataFailure))
                return
            }
                        
            createRequest(with: url, type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        print("Error: \(String(describing: error))")  // Debug print
                        completion(.failure(APIError.dataFailure))
                        return
                    }
                    
                    let jsonString = String(data: data, encoding: .utf8) ?? "Unable to convert data to string"
                    
                    do {
                        let result = try JSONDecoder().decode(RecommendedTracks.self, from: data)
                        completion(.success(result))
                    } catch {
                        print("Decoding error: \(error)")  // Debug print
                        completion(.failure(APIError.decodingFailure))
                    }
                }
                task.resume()
        }
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                print("Error in api url")
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}

