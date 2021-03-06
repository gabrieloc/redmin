//
//  MoreChildrenEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-22.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct MoreChildrenResponse: Decodable {
	struct Body: Decodable {
		struct Things: Decodable {
			let things: [Node<Conversation.Item>]
		}
		let errors: [String]
		let data: Things
	}
	let json: Body
	
	public var errors: [String] {
		return json.errors
	}
	
	public var items: [Conversation.Item] {
		return json.data.things.compactMap { $0.data }
	}
}

public struct MoreChildrenEndpoint: Endpoint {
	public typealias R = MoreChildrenResponse

	let maxChildren = 100
	let more: More
	public let resourcePath: String
	
	public init(more: More) {
		self.more = more
		self.resourcePath = "api/morechildren"
	}
	
	public var queryItems: [URLQueryItem]? {
		let childCount = min(more.children.count, maxChildren)
		return [
			URLQueryItem(name: "children", value: more.children[0..<childCount].joined(separator: ",")),
			URLQueryItem(name: "api_type", value: "json"),
			URLQueryItem(name: "link_id", value: more.parentID)
		]
	}
}
