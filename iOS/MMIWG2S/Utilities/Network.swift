//
//  Network.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 4/7/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import Foundation

enum HttpContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
    case multipartForm = "multipart/form-data; boundary="
    case all = "*/*"
}

class Network {
    
    /**
     - Parameter url: URL for the POST request
     - Parameter data: the data to be posted
     - Parameter completionHandler: response from HTTP request
     - error: HTTP Error or error if response is unable to be decoded
     - response: decoded JSON response from HTTP Request
     */
    static func post(url: String, data: [AnyHashable : Any] = [:], header: [String : String] = [:], contentType: HttpContentType = .json, completionHandler: @escaping ((_ error: String?,_ response: Data?) -> Void)) {
        guard let fullUrl = URL(string: url) else {
            completionHandler("Error creating url", nil)
            return
        }
        log.debug("Attempting to make http request to \(fullUrl.absoluteString)")
        var request = URLRequest(url: fullUrl)
        let boundary = contentType == .multipartForm ? UUID().uuidString : ""
        request.httpMethod = "POST"
        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.addValue("\(HttpContentType.json.rawValue)\(boundary)", forHTTPHeaderField: "Accept")
        do {
            switch contentType {
            case .json:
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            case .form:
                guard let data = data as? [String : String], let parameterString = parameterString(from: data) else {
                    completionHandler("Error creating url", nil)
                    return
                }
                request.httpBody = parameterString.data(using: .utf8)
            case .multipartForm:
                var multiPartData = Data()
                guard let data = data as? [String:(String,Data)] else {
                    log.error("Incorrect format for multipart form")
                    completionHandler("incorrect data format", nil)
                    return
                }
                data.forEach {
                    let ext = "\($0.value.0.split(separator: "/").last ?? "")"
                    multiPartData.addMultiPart(boundary: boundary, name: $0.key, filename: "\($0.key).\(ext)", contentType: $0.value.0, data: $0.value.1)
                }
                multiPartData.addMultiPartEnd(boundary: boundary)
                request.httpBody = multiPartData
            default:
                break
            }
        } catch let error {
            log.error(error.localizedDescription)
        }
        
        makeRequest(request: &request, header: header, completionHandler: completionHandler)
    }
    
    /**
     - Parameter url: URL for the POST request
     - Parameter data: the data to be posted
     - Parameter completionHandler: response from HTTP request
     - error: HTTP Error or error if response is unable to be decoded
     - response: decoded JSON response from HTTP Request
     */
    static func put(url: String, data: [String : String] = [:], header: [String : String] = [:], completionHandler: @escaping ((_ error: String?,_ response: Data?) -> Void)) {
        guard let fullUrl = URL(string: url) else {
            completionHandler("Error creating url", nil)
            return
        }
        log.debug("Attempting to make http request to \(fullUrl.absoluteString)")
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "PUT"
        makeRequest(request: &request, header: header, completionHandler: completionHandler)
    }
    
    /**
     - Parameter url: URL for the POST request
     - Parameter data: the data to be posted
     - Parameter completionHandler: response from HTTP request
     - error: HTTP Error or error if response is unable to be decoded
     - response: decoded JSON response from HTTP Request
     */
    static func get(url: String, data: [String : String] = [:], header: [String : String] = [:], completionHandler: @escaping ((_ error: String?,_ response: Data?) -> Void)) {
        guard let parameterString = parameterString(from: data), let fullUrl = URL(string: url.appending("/?\(parameterString)")) else {
            completionHandler("Error creating url", nil)
            return
        }
        log.debug("Attempting to make http request to \(fullUrl.absoluteString)")
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        makeRequest(request: &request, header: header, completionHandler: completionHandler)
    }
    
    private static func makeRequest(request: inout URLRequest, header: [String : String], completionHandler: @escaping ((_ error: String?,_ response: Data?) -> Void)) {
        let session = URLSession.shared
        header.forEach { header, value in
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, 300...599 ~= httpResponse.statusCode {
                log.error("HTTP ERROR: \(httpResponse.statusCode): \(httpResponse.description)")
                completionHandler("\(httpResponse.statusCode): \(httpResponse.description)", nil)
            } else {
                completionHandler(error.debugDescription, data)
            }
        })
        task.resume()
    }
    
    private static func parameterString(from data: [String : String]) -> String? {
        return data
            .map { "\($0.key)=\($0.value)" }
            .reduce("") { $0.isEmpty ? "\($1)" : "\($0)&\($1)" }
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}
