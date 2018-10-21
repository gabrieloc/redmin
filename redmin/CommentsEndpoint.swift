//
//  CommentsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct CommentsResponse: Decodable {
	public let post: Post
	public let comments: [Comment]
	public let more: More?
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let postNode = try container.decode(Node.self)
		post = postNode.data.children.compactMap { $0.data as? Post }.first!
		
		let commentsNode = try container.decode(Node.self)
		comments = commentsNode.data.children.compactMap { $0.data as? Comment }
		more = commentsNode.data.children.compactMap { $0.data as? More }.first
	}
}

public struct CommentsEndpoint: Endpoint {
	public typealias R = CommentsResponse
	
	public enum Sort: String, CaseIterable {
		case confidence, top, new, controversial, old, random, qa, live
	}
	
	public static let defaultLimit = 100
	public let session = URLSession(configuration: .default)
	
	let path: String
	let sort: Sort
	let limit: Int
	
	public init(post: Post, sort: Sort = .top, limit: Int = CommentsEndpoint.defaultLimit) {
		self.path = post.commentsPath
		self.sort = sort
		self.limit = limit
	}
	
	public var resourcePath: String {
		return path
	}
	
	public var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "sort", value: sort.rawValue),
			URLQueryItem(name: "limit", value: String(limit))
		]
	}
}
