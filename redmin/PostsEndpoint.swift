//
//  PostsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct PostsResponse: Decodable {
	let postNode: Node<ListingNode<Post>>
	
	public let posts: [Post]
	
	public var nextPage: Fullname? {
		return postNode.data.after
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		postNode = try container.decode(Node.self)
		posts = postNode.data.children.compactMap { $0.data }
	}
}

public enum PostCategory: String, CaseIterable {
	case hot, new, rising, top
}

public struct PostsEndpoint: Endpoint {
	public typealias R = PostsResponse
	
	public let session = URLSession(configuration: .default)
	public var subreddit: String?
	public var category: PostCategory
	public var limit: Int
	public var after: Fullname?
	
	public init(subreddit: String?, category: PostCategory, limit: Int, after: Fullname? = nil) {
		self.subreddit = subreddit
		self.category = category
		self.limit = limit
		self.after = after
	}
	
	public var resourcePath: String {
		if let subreddit = self.subreddit {
			return "\(subreddit)/\(category.rawValue)"
		}
		return category.rawValue
	}
	
	public var queryItems: [URLQueryItem]? {
		var items = [
			URLQueryItem(name: "limit", value: String(limit)),
		]
		if let after = self.after {
			items.append(URLQueryItem(name: "after", value: after))
		}
		
		return items
	}
}
