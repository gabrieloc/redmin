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
	public static let shared = NetworkService()
	
	public enum Authentication {
		case none
		case authorized(clientID: String)
		case authenticated(accessToken: String)
	}
	
	public var authentication: Authentication
	
	public var isAuthenticated: Bool {
		if case Authentication.authenticated = authentication {
			return true
		}
		return false
	}

	var baseURL: URL {
		let path: String = {
			switch authentication {
			case .authenticated:
				return "https://oauth.reddit.com"
			default:
				return "https://www.reddit.com"
			}
		}()
		return URL(string: path)!
	}
	
	public func headers(contentType: ContentType) -> [String: String] {
		var headers = [
			"Content-Type": contentType.rawValue
		]
		switch authentication {
		case .none:
			break
		case .authorized(let clientID):
			let token = "\(clientID):"
			let encoded = token.data(using: String.Encoding.utf8)!.base64EncodedString()
			headers["Authorization"] = "Basic \(encoded)"
		case .authenticated(let accessToken):
			headers["Authorization"] = "bearer \(accessToken)"
		}
		return headers
	}

	internal init() {
		authentication = .none
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
