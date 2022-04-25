//
//  APIManager.swift
//  Converter
//
//  Created by abhisheksingh03 on 23/04/22.
//

import Foundation

struct APIServiceManager {

    private func createUrlRequest(
        service: APIService,
        completion: @escaping(Callback<URLRequest>)) {
        let token = ""
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
            let error = NSError(domain: "Invalid url", code: 450, userInfo: [:])
            completion(.failure(ErrorResponse(error: error)))
            return
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
        completion(.success(request))
    }

    func getResponseSession<T: Decodable>(
        service: APIService,
        completion: @escaping(Callback<T>)) {
        let semaphore = DispatchSemaphore(value: 0)
        //Method body
        createUrlRequest(service: service) { (response) in
            switch response {
            case .success(let request):
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        self.parseResponse(data: data, response: response, error: error, completion: completion)
                    }
                    semaphore.signal()
                }
                task.resume()
                semaphore.wait()
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(ErrorResponse(error: error)))
                }
            }
        }
    }

    private func parseResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping(Callback<T>)) {
        guard let httpResponse = response as? HTTPURLResponse,
              let data = data else {
            completion(.failure(ErrorResponse(error: "No data received")))
            return
        }
        do {
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                let successResponse = try decoder.decode(T.self, from: data)
                completion(.success(successResponse))
            default:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(.failure(errorResponse))
            }
        } catch {
            completion(.failure(ErrorResponse(error: error)))
        }
    }
}
