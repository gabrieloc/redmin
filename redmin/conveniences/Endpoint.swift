//
//  Endpoint.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public enum ContentType: String {
	case form = "application/x-www-form-urlencoded"
	case json = "application/json"
}

public enum NetworkError: Error {
	case invalidResponse(statusCode: Int)
	case corruptResponse
	
	public var isAuthenticationRequired: Bool {
		switch self {
		case .invalidResponse(let statusCode):
			return statusCode == 403
		default:
			return false
		}
	}
}

public enum EndpointResponse<Response> {
	case success(Response)
	case failure(Error)
}

public enum Method {
	case get
	case post(body: [String: String])
	
	var rawValue: String {
		switch self {
		case .get:
			return "GET"
		case .post:
			return "POST"
		}
	}
}

public protocol Endpoint {
	associatedtype R: Decodable
	var resourcePath: String { get }
	var queryItems: [URLQueryItem]? { get }
	var method: Method { get }
	var contentType: ContentType { get }
}

fileprivate let decoder = JSONDecoder()

extension Endpoint {
	public var queryItems: [URLQueryItem]? {
		return nil
	}
	
	public var contentType: ContentType {
		return .json
	}
	
	public var method: Method {
		return .get
	}
	
	var components: URLComponents {
		let url = "\(resourcePath)\(contentType == .json ? ".json" : "")"
		var components = URLComponents(string: url)!
		components.queryItems = [URLQueryItem(name: "raw_json", value: "1")] + (queryItems ?? [])
		return components
	}
	
	@discardableResult
	public func request(_ completion: @escaping ((EndpointResponse<R>) -> Void)) -> URLSessionDataTask {
		print("requesting \(components.url?.absoluteString ?? resourcePath)")
		return NetworkService.shared.request(
			components,
			contentType: contentType,
			method: method,
			completion: { (data, response, error) in
				let response = self.createResponse(data, response, error)
				completion(response)
		})
	}
	
	func createResponse(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> EndpointResponse<R> {
		guard
			let data = data,
			let httpResponse = urlResponse as? HTTPURLResponse
			else {
				return .failure(error ?? NetworkError.corruptResponse)
		}
		
		guard (200..<300).contains(httpResponse.statusCode) else {
			return .failure(NetworkError.invalidResponse(statusCode: httpResponse.statusCode))
		}
		
		do {
			let decoded = try decoder.decode(R.self, from: data)
			return .success(decoded)
		} catch (let error) {
			print(error)
			return .failure(error)
		}
	}
}
