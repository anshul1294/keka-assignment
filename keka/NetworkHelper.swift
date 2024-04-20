//
// NetworkHelper.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case imageError
    case noInternetConnection
    case other(Error)
}

class NetworkHelper {
    
    static public let shared = NetworkHelper()
    private let session: URLSession
    
    private init(){
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 5
        session = URLSession(configuration: config)
    }
    
    struct Endpoint {
        static let getDocData = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM"
    }
   
    func fetchDocsFromNetwork(from endpoint: String, completion: @escaping (Result<MainResponse, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        getData(from: urlRequest, completion: completion)
    }
}


extension NetworkHelper {
    
    func isNetworkReachable() -> Bool {
        guard let url = URL(string: "https://www.google.com") else { return false }
        let semaphore = DispatchSemaphore(value: 0)
        
        var result = false
        let task = session.dataTask(with: url) { (_, response, error) in
            if let error = error {
                print("Error occurred while checking internet connectivity: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                result = true
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .now() + 5) // Wait for 5 seconds
        
        return result
    }
    
    func getData<T: Decodable>(from request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard isNetworkReachable() else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let string = try JSONSerialization.jsonObject(with: data)
                print(string)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: "https://static01.nyt.com/" + urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.imageError))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
}
