//
//  Conversation.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-22.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Conversation: Decodable {
	
	public enum Item: Resource, Decodable {
		enum ItemError: Error {
			case unknownType
		}
		
		case comment(Comment)
		case more(More)
		
		public var data: Any {
			switch self {
			case .comment(let comment):
				return comment
			case .more(let more):
				return more
			}
		}
		
		public init(from decoder: Decoder) throws {
			if let comment = try? Comment(from: decoder) {
				self = .comment(comment)
			} else if let more = try? More(from: decoder) {
				self = .more(more)
			} else {
				throw ItemError.unknownType
			}
		}
	}
	
	public let post: Post
	public let items: [Item]
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let postNode = try container.decode(Node<ListingNode<Post>>.self)
		post = postNode.data.children.compactMap { $0.data }.first!
		
		let itemsNode = try container.decode(Node<ListingNode<Item>>.self)
		var items = [Item]()
		Conversation.aggregateDescendants(of: itemsNode.data.children.map { $0.data }, into: &items)
		self.items = items
	}
	
	
	static func aggregateDescendants(of items: [Item], into collection: inout [Item]) {		
		for item in items {
			collection.append(item)
			guard
				let comment = item.data as? Comment,
				let replyNode = comment.replyNode
				else {
					return
			}
			let replies = replyNode.data.children.map { $0.data }
			aggregateDescendants(of: replies, into: &collection)
		}
	}
}
