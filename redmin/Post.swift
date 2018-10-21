//
//  Post.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Post: Decodable {
	public struct Preview: Decodable {
		public struct PreviewImages: Decodable {
			public let source: Image
			public let resolutions: [Image]
		}
		public let images: [PreviewImages]
		public let enabled: Bool
	}
	
	public let id: String
	public let title: String
	public let text: String?
	public let subreddit: String
	public let commentCount: Int?
	public let preview: Preview?
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case text = "selftext"
		case subreddit = "subreddit_name_prefixed"
		case commentCount = "num_comments"
		case preview
	}
	
	var commentsPath: String {
		return [subreddit, "comments", id].joined(separator: "/")
	}
	
	public func textPreview(until endIndex: Int = 150) -> String? {
		guard let text = self.text else {
			return nil
		}
		
		let preview: String = {
			if let firstParagraph = text.components(separatedBy: .newlines).first,
				firstParagraph.count < endIndex {
				return firstParagraph
			}
			let slice = text[..<text.index(text.startIndex, offsetBy: min(text.count, endIndex))]
			return String(slice)
		}()
		
		return "\(preview.trimmingCharacters(in: .whitespacesAndNewlines))..."
	}
}
