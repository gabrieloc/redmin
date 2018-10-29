//
//  Comment.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Comment: Resource {
	internal static let font: UIFont = .systemFont(ofSize: 14)
	
	public let author: String
	public let body: String
	public let score: Int
	
	public let id: String
	public let parentID: String
	public let depth: Int
	
	public let createdAt: Date

	var replyNode: Node<ListingNode<Conversation.Item>>?

	public let bodyHTML: NSAttributedString
	
	enum CodingKeys: String, CodingKey {
		case author
		case body
		case depth
		case id
		case parentID = "parent_id"
		case bodyHTML = "body_html"
		case replyNode = "replies"
		case score
		case createdAt = "created_utc"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		author = try container.decode(String.self, forKey: .author)
		body = try container.decode(String.self, forKey: .body)
		depth = try container.decode(Int.self, forKey: .depth)
		id = try container.decode(String.self, forKey: .id)
		parentID = try container.decode(String.self, forKey: .parentID)
		score = try container.decode(Int.self, forKey: .score)
		replyNode = try? container.decode(Node<ListingNode<Conversation.Item>>.self, forKey: .replyNode)
		
		let unixCreatedAt = try container.decode(Double.self, forKey: .createdAt)
		createdAt = Date(timeIntervalSince1970: unixCreatedAt)
	
		let rawHTML = try container.decode(String.self, forKey: .bodyHTML)
		bodyHTML = rawHTML.htmlAttributedString(font: Comment.font)
	}

	static func aggregateDescendants(of comment: Comment, into collection: inout [Comment]) {
		let itemNodes = comment.replyNode?.data.children
		let comments: [Comment]? = itemNodes?.compactMap { itemNode in
			guard case Conversation.Item.comment(let comment) = itemNode.data else {
				return nil
			}
			return comment
		}
		comments?.forEach { reply in
			collection.append(reply)
			aggregateDescendants(of: reply, into: &collection)
		}
	}
	
	public var durationSinceCreation: String {
		let time = -createdAt.timeIntervalSinceNow
		return time.prettyDuration
	}
}
