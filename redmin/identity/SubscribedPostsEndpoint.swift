//
//  SubscribedPostsEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-11-04.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public class SubscribedPostsEndpoint: PostsEndpoint {
	public override var resourcePath: String {
		return "subreddits/mine/subscriber"
	}
}
