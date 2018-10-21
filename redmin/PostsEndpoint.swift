//
//  PostsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct PostsResponse: Decodable {
	let postNode: Node
	
	public let posts: [Post]
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		postNode = try container.decode(Node.self)
		posts = postNode.data.children.compactMap { $0.data as? Post }
	}
}

public struct PostsEndpoint: Endpoint {
	public typealias R = PostsResponse
	
	public let session = URLSession(configuration: .default)
	
	public enum Category: String, CaseIterable {
		case hot, new, rising, top
	}
	
	public var subreddit: String?
	public var category: Category
	public var limit: Int
	
	public init(subreddit: String?, category: Category, limit: Int) {
		self.subreddit = subreddit
		self.category = category
		self.limit = limit
	}
	
	public var resourcePath: String {
		if let subreddit = self.subreddit {
			return "\(subreddit)/\(category.rawValue)"
		}
		return category.rawValue
	}
	
	public var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "limit", value: String(limit))
		]
	}
}
