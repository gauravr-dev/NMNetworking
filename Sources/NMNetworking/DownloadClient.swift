//
//  DownloadClient.swift
//  Created by Gaurav Rajput


import Foundation

class DownloadClient<APIRequest: Request>:APIClient<APIRequest> {
    
    func download(_ request: APIRequest, completion: @escaping ResultCallback) {
        do {
            let req: URLRequest = try request.build()
            
            let task = session.downloadTask(with: req, completionHandler: { (url, response, error) in
                // Decode the top level response, and look up the decoded response to see
                // if it's a success or a failure
                if (error != nil) {
                    completion(.failure(.server(message: error!.localizedDescription)))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response: httpResponse)
                    switch result {
                    case .success( _):
                        completion(.success(url?.absoluteString ?? ""))
                    case .failure(let httpError):
                        completion(.failure(httpError))
                    }
                }
            })
            task.resume()
        } catch {
            completion(.failure(.badRequest))
        }
    }
    
}
