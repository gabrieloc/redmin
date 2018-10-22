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

struct ListingNode<T: Resource>: Resource, Decodable {
	let after: String?
	let before: String?
	let children: [Node<T>]
}

struct Node<D: Resource>: Decodable, Resource {
	let kind: Kind
	let data: D
}
