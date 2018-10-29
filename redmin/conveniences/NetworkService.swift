//
//  NetworkService.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-29.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public class NetworkService {
	let session = URLSession.shared
	public var authentication: (clientID: String, token: String)? = nil
	public static let shared = NetworkService()

	var baseURL: URL {
		let path: String = {
			if authentication?.token != nil {
				return "https://oauth.reddit.com"
			}
			return "https://www.reddit.com"
		}()
		return URL(string: path)!
	}
	
	public func headers(contentType: ContentType) -> [String: String] {
		var headers = [
			"Content-Type": contentType.rawValue
		]
		if let authentication = authentication {
			let value: String = {
				if authentication.token.isEmpty {
					let encoded = authentication.clientID.data(using: String.Encoding.utf8)!.base64EncodedString()
					return "Basic \(encoded)"
				} else {
					return "bearer \(authentication.token)"
				}
			}()
			headers["Authorization"] = value
			
		}
		return headers
	}

	internal init() {
		authentication = nil
	}
	
	func request(_ components: URLComponents, contentType: ContentType, method: Method, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask {
		var request = URLRequest(url: components.url(relativeTo: baseURL)!)
		request.allHTTPHeaderFields = headers(contentType: contentType)
		request.httpMethod = method.rawValue
		if case Method.post(let body) = method {
			request.httpBody = body.formEncoded!
		}
		let task = session.dataTask(with: request, completionHandler: completion)
		task.resume()
		return task
	}
}
