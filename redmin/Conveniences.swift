//
//  Conveniences.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-21.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

extension Int {
	public func posts(category: PostsEndpoint.Category = .hot, _ completion: @escaping (([Post]) -> Void)) {
		postsFromSubreddit(named: nil, category: category, completion)
	}
	
	public func postsFromSubreddit(named name: String?, category: PostsEndpoint.Category = .hot, _ completion: @escaping (([Post]) -> Void)) {
		PostsEndpoint(subreddit: name, category: category, limit: self).request { (response) in
			guard case EndpointResponse<PostsEndpoint.R>.success(let postsResponse) = response else {
				return
			}
			completion(postsResponse.posts)
		}
	}
	
	public func commentsFromPost(_ post: Post, sort: CommentsEndpoint.Sort = .top, _ completion: @escaping (([Comment]) -> Void)) {
		CommentsEndpoint(post: post, sort: sort, limit: self).request { (response) in
			guard
				case EndpointResponse<CommentsEndpoint.R>.success(let commentsResponse) = response else {
					return
			}
			let comments = commentsResponse.items.compactMap { $0.data as? Comment }
			completion(comments)
		}
	}
	
	public func commentsFromSubreddit(named name: String?, category: PostsEndpoint.Category = .hot, sort: CommentsEndpoint.Sort = .top, _ completion: @escaping (([Comment]) -> Void)) {
		let sampleSize = 100
		sampleSize.postsFromSubreddit(named: name, category: category) { (posts) in
			self.aggregateComments(from: posts) {
				completion($0)
			}
		}
	}
	
	private func aggregateComments(from posts: [Post], completion: @escaping (([Comment]) -> Void)) {
		var aggregation = [Comment]()
		posts.forEach { post in
			commentsFromPost(post) { (comments) in
				aggregation += comments
//				aggregation += comments.flatMap { $0.descendants }
				
				if aggregation.count >= self || post == posts.last! {
					completion(Array(aggregation[0..<self]))
				}
			}
		}
	}
}
