//
//  PostsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct PostsResponse: Decodable {
	let postNode: Node<Post>
	
	public var posts: [Post] {
		return postNode.data.children?.map { $0.data } ?? [Post]()
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		postNode = try container.decode(Node<Post>.self)
	}
}

public struct PostsEndpoint: Endpoint {
	public typealias R = PostsResponse
	
	public static let defaultLimit = 100
	public let session = URLSession(configuration: .default)
	
	public enum Category: String, CaseIterable {
		case hot, new, rising, top
	}
	
	public static var hot = PostsEndpoint(category: .hot)
	public static var new = PostsEndpoint(category: .new)
	public static var rising = PostsEndpoint(category: .rising)
	public static var top = PostsEndpoint(category: .top)
	
	public var category: Category
	public var limit: Int
	
	public init(category: Category, limit: Int = PostsEndpoint.defaultLimit) {
		self.category = category
		self.limit = limit
	}
	
	public var resourcePath: String {
		return category.rawValue
	}
	
	public var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "limit", value: String(limit))
		]
	}
}
