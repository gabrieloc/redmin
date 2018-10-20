//
//  Image.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import UIKit

public struct Image: Codable {
	public let url: URL
	public let width: CGFloat
	public let height: CGFloat
	
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
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(url, forKey: .url)
		try container.encode(width, forKey: .width)
		try container.encode(height, forKey: .height)
	}
	
	var dataTask: URLSessionDataTask?
	
	static let cache = NSCache<NSString, UIImage>()
	static let session = URLSession(configuration: .default)

	public enum ImageError: Error {
		case generic
	}
	
	public mutating func fetch(_ completion: @escaping (EndpointResponse<UIImage>) -> Void) {
		let key = url.absoluteString as NSString
		if let image = Image.cache.object(forKey: key) {
			completion(.success(image))
			return
		}
		let request = URLRequest(
			url: url,
			cachePolicy: .returnCacheDataElseLoad,
			timeoutInterval: 10
		)
		dataTask = Image.session.dataTask(with: request) { (data, _, error) in
			guard let data = data, let image = UIImage(data: data) else {
				completion(.failure(error ?? ImageError.generic))
				return
			}
			Image.cache.setObject(image, forKey: key)
			completion(.success(image))
		}
		dataTask?.resume()
	}
	
	public mutating func cancel() {
		dataTask?.cancel()
		dataTask = nil
	}
}
