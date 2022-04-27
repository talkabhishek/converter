//
//  APIManager.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

struct APIServiceManager {

    private func createUrlRequest(token: String = "", service: APIService) -> URLRequest? {
        var query = "?"
        for (key, value) in service.queryParams {
            if query != "?" {
                query += "&"
            }
            query += key + "=" + value
        }
        let urlString = service.baseUrl + service.path + query
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            return nil
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = service.method
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("no-store, no-cache", forHTTPHeaderField: "Cache-Control")
        request.cachePolicy = .reloadIgnoringCacheData

        if let bodyParams = service.bodyParams {
            if bodyParams is Data {
                request.httpBody = bodyParams as? Data
            } else {
                let postData = try? JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                request.httpBody = postData
            }
        }
        return request
    }

    func getResponseSession<T: Decodable>(
        service: APIService,
        completion: @escaping(Callback<T>)) {
        let semaphore = DispatchSemaphore(value: 0)
        //Method body
        guard let request = createUrlRequest(service: service) else {
            let error = NSError(domain: "Invalid url", code: 450, userInfo: [:])
            completion(.failure(ErrorResponse(error: error)))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                let model = try decoder.decode(T.self, from: data ?? Data())
                completion(.success(model))
            } catch let decodeError {
                completion(.failure(ErrorResponse(error: error ?? decodeError)))
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

}
