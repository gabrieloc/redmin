//
//  Post.swift
//  redditlight
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-19.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Post: Resource, Decodable, Equatable {
	public struct Preview: Decodable, Equatable {
		public struct PreviewImages: Decodable, Equatable {
			public let source: Image
			public let resolutions: [Image]
		}
		public let images: [PreviewImages]
		public let enabled: Bool
	}
	
	public let id: String
	public let title: String
	public let text: String?
	public let attributedText: NSAttributedString?
	public let subreddit: String
	public let commentCount: Int
	public let preview: Preview?
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case text = "selftext"
		case textHTML = "selftext_html"
		case subreddit = "subreddit_name_prefixed"
		case commentCount = "num_comments"
		case preview
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		text = try? container.decode(String.self, forKey: .text)
		subreddit = try container.decode(String.self, forKey: .subreddit)
		commentCount = try container.decode(Int.self, forKey: .commentCount)
		preview = try? container.decode(Preview.self, forKey: .preview)
		
		if let rawHTML = try? container.decode(String.self, forKey: .textHTML) {
			attributedText = rawHTML.htmlAttributedString(
				font: .systemFont(ofSize: 13)
			)
		} else {
			attributedText = nil
		}
	}
	
	var commentsPath: String {
		return [subreddit, "comments", id].joined(separator: "/")
	}
	
	public func textPreview(until endIndex: Int = 150) -> String? {
		guard let text = self.attributedText?.string else {
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
	
	public var bestPreviewImage: Image? {
		return preview?.images.last?.source
	}
}
