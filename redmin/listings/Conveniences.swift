//
//  Conveniences.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-21.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

// 	NOTE:
// 	The code in this file is extremely hacky and inefficient and should not be
//	used for any sort of production project.

extension Int {
	public func comments(category: PostCategory = .top, _ completion: @escaping (([Comment]) -> Void )){
		commentsFromSubreddit(named: nil, category: category, sort: .top, completion)
	}
	
	public func posts(category: PostCategory = .top, _ completion: @escaping (([Post]) -> Void)) {
		postsFromSubreddit(named: nil, category: category, completion)
	}
	
	// TODO this is limited to 100 posts at a time (API constraint).
	//			To get more posts, pass the nextPage property on PostsResponse to PostsEndpoint
	//			for each subsequent request
	public func postsFromSubreddit(named name: String?, category: PostCategory = .top, _ completion: @escaping (([Post]) -> Void)) {
		PostsEndpoint(subreddit: name, category: category, limit: self).request { (response) in
			guard case EndpointResponse<PostsEndpoint.R>.success(let postsResponse) = response else {
				return
			}
			completion(postsResponse.posts)
		}
	}
	
	public func commentsFromPost(_ post: Post, sort: Sort = .top, _ completion: @escaping (([Comment]) -> Void)) {
		let goal = self
		var aggregation = [Comment]()
		
		ConversationEndpoint(post: post, sort: sort, limit: self).request { (response) in
			guard
				case EndpointResponse<ConversationEndpoint.R>.success(let commentsResponse) = response else {
					return
			}
			
			func deepAggregateComments(from items: [Conversation.Item], completion: @escaping (() -> Void)) {
				guard aggregation.count < goal else {
					completion()
					return
				}
				aggregateReplies(of: items.comments) {
					if let more = items.more {
						aggregatePagedComments(with: more) {
							completion()
						}
					} else {
						completion()
					}
				}
			}
			
			let comments = commentsResponse.items.comments
			aggregation += comments
			
			func aggregateReplies(of comments: [Comment], _ completion: @escaping () -> Void) {
				guard aggregation.count < goal, let replyNode = comments.first?.replyNode else {
					completion()
					return
				}
				aggregation += comments
				let items = replyNode.data.children.compactMap { $0.data }
				deepAggregateComments(from: items, completion: completion)
			}
			
			func aggregatePagedComments(with more: More, _ completion: @escaping () -> Void) {
				guard aggregation.count < goal else {
					completion()
					return
				}
				
				MoreChildrenEndpoint(more: more).request { response in
					guard
						case EndpointResponse<MoreChildrenEndpoint.R>.success(let moreResponse) = response else {
						completion()
						return
					}
					
					aggregation += moreResponse.items.comments
					
					if let more = moreResponse.items.more {
						aggregatePagedComments(with: more, completion)
					} else {
						completion()
					}
				}
			}
			
			deepAggregateComments(from: commentsResponse.items) {
				completion(aggregation)
			}
		}
	}
	
	public func commentsFromSubreddit(named name: String?, category: PostCategory = .top, sort: Sort = .top, _ completion: @escaping (([Comment]) -> Void)) {
		
		let goal = self
		var aggregation = [Comment]()
		
		func aggregateComments(from posts: [Post], completion: @escaping (([Comment]) -> Void)) {
			guard let post = posts.first, aggregation.count < goal else {
				completion(aggregation)
				return
			}
			
			commentsFromPost(post) { comments in
				aggregation += comments
				print(aggregation.count)
				aggregateComments(from: Array(posts[1..<posts.count]), completion: completion)
			}
		}
		
		let sampleSize = 100
		sampleSize.postsFromSubreddit(named: name, category: category) { (posts) in
			aggregateComments(from: posts) {
				completion($0)
			}
		}
	}
}
