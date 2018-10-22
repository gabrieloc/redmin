//
//  CommentsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct CommentsEndpoint: Endpoint {
	public typealias R = Conversation
	
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
