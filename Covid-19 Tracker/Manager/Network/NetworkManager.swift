//
//  NetworkManager.swift
//  Covid-19 Tracker
//
//  Created by Luiz on 11/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()

    private let cache = NSCache<NSString, UIImage>()

    private let baseUrl: String = {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        return baseUrl
    }()

    func fetchData<T: Decodable>(endPoint: String, type: T.Type, completion: @escaping (Result<T, ErrorMessages>) ->Void){
        guard let url = URL(string: "\(baseUrl)\(endPoint)") else {
            completion(.failure(ErrorMessages.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(ErrorMessages.unableToComplete))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(ErrorMessages.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(ErrorMessages.invalidData))
                return
            }

            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(ErrorMessages.invalidData))
                return
            }

            completion(.success(result))
        }.resume()
    }

    func download(stringURL: String, completion: @escaping (Result<UIImage, ErrorMessages>) -> Void) {
        if let image = cache.object(forKey: NSString(string: stringURL)) {
            completion(.success(image))
            return
        }

        guard let url = URL(string: stringURL) else {
            completion(.failure(ErrorMessages.invalidURL))
            return
        }

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                completion(.failure(ErrorMessages.invalidData))
                return
            }

            self.cache.setObject(image, forKey: NSString(string: stringURL))
            completion(.success(image))
        }
        dataTask.resume()
    }
}
