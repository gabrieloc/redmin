//
//  Post.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Post: Resource {
	public struct Preview: Codable {
		public struct PreviewImages: Codable {
			public let source: Image
			public let resolutions: [Image]
		}
		public let images: [PreviewImages]
		public let enabled: Bool
	}
	
	public let id: String
	public let title: String
	public let text: String?
	public let subreddit: String
	public let commentCount: Int?
	public let preview: Preview?
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case text = "selftext"
		case subreddit = "subreddit_name_prefixed"
		case commentCount = "num_comments"
		case preview
	}
	
	var commentsPath: String {
		return [subreddit, "comments", id].joined(separator: "/")
	}
	
	public func textPreview(until endIndex: Int = 150) -> String? {
		guard let text = self.text else {
			return nil
		}
		let preview = text[..<text.index(text.startIndex, offsetBy: min(text.count, endIndex))].trimmingCharacters(in: .whitespacesAndNewlines)
		return "\(preview)..."
	}
}

public struct PostsResponse: Response {
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
	
	public enum Category: String {
		case hot, new, random, rising, top
	}
	
	let _category: Category
	let limit: Int
	
	public var category: String {
		return _category.rawValue
	}
	
	public init(category: Category, limit: Int) {
		self._category = category
		self.limit = limit
	}
	
	public var resourcePath: String {
		return category
	}
	
	public var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "limit", value: String(limit))
		]
	}
}
