//
//  SubscriptionsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-30.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public class SubscriptionsEndpoint: PostsEndpoint {
	public override var resourcePath: String {
		return "subreddits/mine/subscriber"
	}
}
