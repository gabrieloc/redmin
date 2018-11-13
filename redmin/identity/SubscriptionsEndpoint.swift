//
//  SubscriptionsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-11-09.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct SubscriptionsEndpoint: ListingEndpoint {
	public typealias R = Listing<Subreddit>
	public var limit: Int = 100
	public var after: Fullname?
	public let resourcePath: String

	public enum `Type`: String {
		case subscriber
		case contributor
		case moderator
		case streams
	}
	
	public init(type: Type) {
		self.resourcePath = "subreddits/mine/\(type.rawValue)"
	}
}
