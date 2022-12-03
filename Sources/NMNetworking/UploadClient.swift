//
//  UploadClient.swift
//  Created by Gaurav Rajput


import Foundation

class UploadClient<APIRequest: Request>: APIClient<APIRequest> {
    
    func upload(_ request: APIRequest,
                ispreloginGetID : Bool = true,
                headersForGetID: [String:String] = [:],
                completion: @escaping ResultCallback
    ) {
        execute(request, completion: completion)
    }
    
    private func execute(_ request: APIRequest, completion: @escaping ResultCallback) {
        do {
            let req: URLRequest = try request.build()

            let task = session.dataTask(with: req) { data, response, error in
                if let data = data {
                    do {
                        // Decode the top level response, and look up the decoded response to see
                        // if it's a success or a failure
                        if let httpResponse = response as? HTTPURLResponse {
                            let result = self.handleNetworkResponse(response: httpResponse)
                            
                            switch result {
                                case .success( _):
                                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                                    completion(.success(responseObject))
                                case .failure(let httpError):
                                    completion(.failure(httpError))
                            }
                        }
                    } catch {
                        if let filename = String(data: data, encoding: .utf8) {
                            completion(.success(filename))
                        } else {
                            completion(.failure(.server(message: error.localizedDescription)))
                        }
                        
                       
                    }
                } else if let error = error {
                    completion(.failure(.server(message: error.localizedDescription)))
                }
            }
            task.resume()
        } catch {
            completion(.failure(.badRequest))
        }
    }
}

enum UploadRequest {
    case upload(data:Data, params:Parameters = [:])
    case uploadFile(filePath:String, params:Parameters = [:])
}

//extension UploadRequest: Request {
//    var baseURL: URL? {
//        URL(string: "")
//    }
//    
//    var contentType: ContentType {
//        .form
//    }
//    
//    var path: String {
//        switch self {
//        case .upload(_, let params):
//            let filename = params[AttachmentKey.mediaName.rawValue] as? String ?? ""
//            let url = Utility.createDownloadEncryptedPathForImage(attachmentName: filename, path: "Notification", url: "")
//            return url
//        case .uploadFile(_, _):
//            return ""
//        }
//    }
//    
//    var httpMethod: HTTPMethod {
//        .post
//    }
//    
//    var task: HTTPTask {
//        switch self {
//        case .upload(let data, let params):
//            return .upload(data: data, parameters: params)
//        case .uploadFile(let filePath, let params):
//            return .uploadFile(filePath: filePath, parameters: params)
//        }
//    }
//    
//    var headers: HTTPHeaders {
//        [:]
//    }
//    
//    func build() throws -> URLRequest {
//        // check if url is configured properly or not
//        guard let baseURL = self.baseURL else {
//            throw HTTPError.missingURL
//        }
//        
//        let url = URL(string: baseURL.absoluteString + self.path)!
//        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TIMEOUT_INTERVAL)
//        
//        request.httpMethod = self.httpMethod.rawValue
//        
//        switch task {
//        case .upload(let data, let parameters):
//            let boundary = "---------------------------14737809831466499882746641449"
//            var mimeType = "image/jpeg" //"application/octet-stream"
//            let filePathKey = "userfile"
//            
//            let fileName = parameters?[AttachmentKey.mediaName.rawValue] as? String ?? "filename"
//            
//            if fileName.contains(".png") {
//                mimeType = "image/png"
//            }
//            if fileName.contains(".mov") {
//                mimeType = "video/mov"
//            }
//            if fileName.contains(".mp4") {
//                mimeType = "video/mp4"
//            }
//            if fileName.contains(".gif") {
//                mimeType = "image/gif"
//            }
//            if (fileName.contains("bmp")) {
//                mimeType = "application/bmp"
//            }
//            
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            
//            let httpBody = NSMutableData()
//            
//            httpBody.append(convertFileData(fieldName: filePathKey,
//                                            fileName: fileName,
//                                            mimeType: mimeType,
//                                            fileData: data,
//                                            using: boundary))
//            request.httpBody = httpBody as Data
//        default:
//            print("No need to handle")
//        }
//        
//        return request
//    }
//    
//    func convertFormField(named name: String, value: String, using boundary: String) -> String {
//      var fieldString = "--\(boundary)\r\n"
//      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
//      fieldString += "\r\n"
//      fieldString += "\(value)\r\n"
//
//      return fieldString
//    }
//    
//    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
//       
//        var body = Data()
//        let filePathKey = "userfile"
//        
//        body.appendString(str: "--\(boundary)\r\n")
//        body.appendString(str: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(fileName)\"\r\n")
//        body.appendString(str: "Content-Type: \(mimeType)\r\n\r\n")
//        body.append(fileData)
//        body.appendString(str: "\r\n")
//        body.appendString(str: "--\(boundary)--\r\n")
//        
//        return body
//    }
//}


