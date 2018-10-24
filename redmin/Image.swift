//
//  Image.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import UIKit

public struct Image: Codable, Equatable {
	public let url: URL
	public let width: CGFloat
	public let height: CGFloat
	
	static var timeout: TimeInterval = 10
	
	public var heightRatio: CGFloat {
		return height / width
	}
	
	enum CodingKeys: String, CodingKey {
		case url, width, height
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		url = try container.decode(URL.self, forKey: .url)
		width = try container.decode(CGFloat.self, forKey: .width)
		height = try container.decode(CGFloat.self, forKey: .height)
	}
	
	var dataTask: URLSessionDataTask?
	
	static let session = URLSession(configuration: .default)

	public enum ImageError: Error {
		case corruptData
	}
	
	var request: URLRequest {
		return URLRequest(
			url: url,
			cachePolicy: .returnCacheDataElseLoad,
			timeoutInterval: Image.timeout
		)
	}
	
	// TODO caching not working for some reason
	
	public mutating func fetch(_ completion: @escaping (EndpointResponse<UIImage>) -> Void) {
		dataTask = Image.session.dataTask(with: request) { (data, _, error) in
			guard let data = data, let image = UIImage(data: data) else {
				completion(.failure(error ?? ImageError.corruptData))
				return
			}
			completion(.success(image))
		}
		dataTask?.resume()
	}
	
	public static func warmCache(with image: Image) {
		session.dataTask(with: image.request).resume()
	}
	
	public mutating func cancel() {
		dataTask?.cancel()
		dataTask = nil
	}
}
