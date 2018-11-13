//
//  SubredditsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-30.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct SubredditsEndpoint: ListingEndpoint {
	public typealias R = Listing<Subreddit>
	public var resourcePath: String

	public var limit: Int = 100
	public var after: Fullname?
	
	public enum Grouping: String {
		case popular, new, gold, `default`
	}
	
	public init(grouping: Grouping) {
		self.resourcePath = "subreddits/\(grouping.rawValue)"
	}
}
