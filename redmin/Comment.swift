//
//  Comment.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public class Comment: Decodable {
	public let author: String?
	public let body: String?
	public let score: Int?
	
	public var parent: Comment?
	public var replies: [Comment]?
	
	private var replyNodes: Node<Comment>?
	
	public lazy var descendants: [Comment] = {
		var aggregation = [Comment]()
		aggregateDescendants(of: self, into: &aggregation)
		return aggregation
	}()
	
	public lazy var indentation: Int = {
		var indentation = 0
		var parent = self.parent
		while let p = parent {
			indentation += 1
			parent = p.parent
		}
		return indentation
	}()
	
	enum CodingKeys: String, CodingKey {
		case author, body, score, replyNodes = "replies"
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		author = try? container.decode(String.self, forKey: .author)
		body = try? container.decode(String.self, forKey: .body)
		score = try? container.decode(Int.self, forKey: .score)
		replyNodes = try? container.decode(Node<Comment>.self, forKey: .replyNodes)
		
		associateComments(for: replyNodes)
	}

	func aggregateDescendants(of comment: Comment, into collection: inout [Comment]) {
		comment.replies?.forEach { reply in
			collection.append(reply)
			aggregateDescendants(of: reply, into: &collection)
		}
	}
	
	func associateComments(for node: Node<Comment>?) {
		replies = node?.data.children?.map { $0.data }.filter { $0.body != nil }
		replies?.forEach { [unowned self] reply in
			reply.parent = self
			reply.associateComments(for: reply.replyNodes)
		}
	}
}
