//
//  Listing.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-11-04.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Listing<T: Resource>: Decodable {
	let node: Node<ListingNode<T>>
	
	public var data: [T] {
		return node.data.children.compactMap { $0.data }
	}
	
	public var nextPage: Fullname? {
		return node.data.after
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		node = try container.decode(Node.self)
	}
}
