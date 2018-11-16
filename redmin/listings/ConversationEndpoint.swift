//
//  CommentsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-20.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public enum Sort: String, CaseIterable {
	case confidence, top, new, controversial, old, random, qa, live
}

public struct ConversationEndpoint: Endpoint {
	public typealias R = Conversation
	
	public static let defaultLimit = 100
	public let resourcePath: String
	
	let sort: Sort
	let limit: Int
	
	public init(post: Post, sort: Sort = .top, limit: Int = ConversationEndpoint.defaultLimit) {
		self.resourcePath = post.commentsPath
		self.sort = sort
		self.limit = limit
	}

	public var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "sort", value: sort.rawValue),
			URLQueryItem(name: "limit", value: String(limit))
		]
	}
}
