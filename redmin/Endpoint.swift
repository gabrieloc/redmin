//
//  Endpoint.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

let baseURL = URL(string: "https://www.reddit.com")!

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

public protocol Endpoint {
	associatedtype R: Decodable
	var resourcePath: String { get }
	var queryItems: [URLQueryItem]? { get }
	var session: URLSession { get }
}

fileprivate let decoder = JSONDecoder()

extension Endpoint {
	var queryItems: [URLQueryItem]? {
		return nil
	}
	
	var url: URL {
		let url = baseURL.appendingPathComponent("\(resourcePath).json")
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		components.queryItems = [URLQueryItem(name: "raw_json", value: "1")] + (queryItems ?? [])
		return components.url!
	}
	
	@discardableResult
	public func request(_ completion: @escaping ((EndpointResponse<R>) -> Void)) -> URLSessionDataTask {
		let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
			let response = self.createResponse(data, response, error)
			completion(response)
		})
		
		task.resume()
		return task
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
