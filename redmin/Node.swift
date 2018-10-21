//
//  Node.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

struct Node<T: Decodable>: Decodable {
	struct Data: Decodable {
		struct Child: Decodable {
			let data: T
		}
		let children: [Child]?
	}
	let kind: String
	let data: Data
}
