//
//  Node.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

protocol Resource: Decodable {
}

enum Kind: String, Decodable {
	case t1, t3, more, Listing
}

enum NodeError: Error {
	case invalidKind
}

struct Node: Decodable {
	struct Data: Decodable {
		struct ChildNode: Decodable {
			
			let kind: Kind
			let data: Resource
			
			enum CodingKeys: String, CodingKey {
				case kind, data
			}
			
			init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				kind = try container.decode(Kind.self, forKey: .kind)

				switch kind {
				case .t1:
					data = try container.decode(Comment.self, forKey: .data)
				case .t3:
					data = try container.decode(Post.self, forKey: .data)
				case .more:
					data = try container.decode(More.self, forKey: .data)
				default:
					throw NodeError.invalidKind
				}
			}
		}
		
		let after: String?
		let before: String?
		let children: [ChildNode]
	}
	
	let kind: String
	let data: Data
}
