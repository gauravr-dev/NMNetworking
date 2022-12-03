//
//  APIClient.swift
//
//  Created by Gaurav Rajput

import Foundation

public protocol NetworkClient: AnyObject {
    associatedtype APIRequest = Request
    
    func send(_ request: APIRequest, completion: @escaping ResultCallback)
        
    func cancel()
    
}

public class APIClient<APIRequest: Request>: NetworkClient {
    
    var session = URLSession.shared
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func send(_ request: APIRequest, completion: @escaping ResultCallback) {
        execute(request, completion: completion)
    }
    
    private func execute(_ request: APIRequest, completion: @escaping ResultCallback) {
        do {
            let req: URLRequest = try request.build()
            //Enable Pinning code end
            let task = session.dataTask(with: req) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(.server(message: error.localizedDescription)))
                    }
                    return
                }
                if let data = data {
                    do {
                        // Decode the top level response, and look up the decoded response to see
                        // if it's a success or a failure
                        if let httpResponse = response as? HTTPURLResponse {
                            let result = self.handleNetworkResponse(response: httpResponse)
                            switch result {
                            case .success:
                                let responseObject = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                                DispatchQueue.main.async {
                                    completion(.success(responseObject))
                                }
                            case .failure(let httpError):
                                DispatchQueue.main.async {
                                    completion(.failure(httpError))
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.decoding))
                        }
                    }
                }
            }
            task.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(HTTPError.badRequest))
            }
        }
    }
    
    public func cancel() {}
    
    /// Default handler for HTTP response codes.
    func handleNetworkResponse(response: HTTPURLResponse) -> Result<String, HTTPError> {
        switch response.statusCode {
        case 200...209:
            return .success("Ok")
        case 400...499:
                return .failure(HTTPError.authorizationFail)
        case 500...599:
            return .failure(HTTPError.badRequest)
        case 600:
            return .failure(HTTPError.outdated)
        default:
            return .failure(HTTPError.failed)
        }
    }
}
