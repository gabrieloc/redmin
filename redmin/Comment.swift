//
//  Comment.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public class Comment: Resource {	
	public let author: String
	public let body: String
	private let rawBodyHTML: String
	public let score: Int
	
	public var parent: Comment?
	public private(set) var replies = [Comment]()
	private var replyNodes: Node?
	
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
		case author, body, rawBodyHTML = "body_html", score, replyNodes = "replies"
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		author = try container.decode(String.self, forKey: .author)
		body = try container.decode(String.self, forKey: .body)
		rawBodyHTML = try container.decode(String.self, forKey: .rawBodyHTML)
		score = try container.decode(Int.self, forKey: .score)
		replyNodes = try? container.decode(Node.self, forKey: .replyNodes)
		
		associateComments(for: replyNodes)
	}

	func aggregateDescendants(of comment: Comment, into collection: inout [Comment]) {
		comment.replies.forEach { reply in
			collection.append(reply)
			aggregateDescendants(of: reply, into: &collection)
		}
	}
	
	func associateComments(for node: Node?) {
		replies = node?.data.children.compactMap { $0.data as? Comment } ?? [Comment]()
		replies.forEach { [unowned self] reply in
			reply.parent = self
			reply.associateComments(for: reply.replyNodes)
		}
	}
	
	private var bodyHTML: NSAttributedString?
	
	public func bodyHTML(font: UIFont? = nil, fontSize: CGFloat) -> NSAttributedString? {
		let fontString = "'\(font?.familyName ?? "-apple-system', 'HelveticaNeue', 'sans-serif")'"
		let format = "<span style=\"font-family: \(fontString); font-size: \(fontSize)\">%@</span>"
		let formatted = String(
			format: format,
			rawBodyHTML.trimmingCharacters(in: .whitespacesAndNewlines)
		)
		
		guard
			bodyHTML == nil,
			Thread.isMainThread,
			let data = formatted.data(using: String.Encoding.utf16, allowLossyConversion: false),
			let attributedString = try? NSMutableAttributedString(
				data: data,
				options: [
					.documentType: NSAttributedString.DocumentType.html,
					.characterEncoding: String.Encoding.utf8.rawValue
				],
				documentAttributes: nil)
			else {
				return bodyHTML
		}
		
		if let lastCharacter = attributedString.string.last, lastCharacter == "\n" {
			attributedString.deleteCharacters(in: NSRange(location: attributedString.length-1, length: 1))
		}
		
		bodyHTML = attributedString
		return attributedString
	}
}
