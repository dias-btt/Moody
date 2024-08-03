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
                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingFailure))
                    print("Error \(error)")
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
                    let json = try JSONSerialization.jsonObject(with: data)
                    let result = try JSONDecoder().decode(TopTracksResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingFailure))
                    print("Error \(error)")
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenreResponse, Error>) -> Void)){
        print("creating request...")
        createRequest(
            with: URL(string: Constants.baseAPIUrl + "/recommendations/available-genre-seeds"),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(RecommendedGenreResponse.self, from: data)
                        print(result)
                        completion(.success(result))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendedTracks, Error>) -> Void){
        let seeds = genres.joined(separator: ",")
        guard var urlComponents = URLComponents(string: Constants.baseAPIUrl + "/recommendations") else {
            completion(.failure(APIError.dataFailure))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "seed_genres", value: seeds)
        ]
            
        guard let url = urlComponents.url else {
            completion(.failure(APIError.dataFailure))
            return
        }
        createRequest(with: URL(string: Constants.baseAPIUrl + "/recommendations?seed_genres=\(seeds)"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.dataFailure))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedTracks.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingFailure))
                    print("Error \(error)")
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

