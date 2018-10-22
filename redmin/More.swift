//
//  More.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-21.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct More: Resource, Decodable {
	public let count: Int
	public let children: [String]
	public let depth: Int
	public let parentID: String
	
	enum CodingKeys: String, CodingKey {
		case count, children, depth, parentID = "parent_id"
	}
	
	public var title: String {
		return "\(count) more \(count == 1 ? "reply" : "replies")"
	}
}
