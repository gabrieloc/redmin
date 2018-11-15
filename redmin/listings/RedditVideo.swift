//
//  RedditVideo.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-11-13.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct RedditVideo: Decodable, Equatable {
	public let dashURL: URL
	public let duration: Int
	public let fallbackURL: URL
	public let height: CGFloat
	public let width: CGFloat
	public let hlsURL: URL
	public let isGif: Bool
	public let scrubberMediaURL: URL
	public let transcodingStatus: String
	
	enum CodingKeys: String, CodingKey {
		case dashURL = "dash_url"
		case duration
		case fallbackURL = "fallback_url"
		case height
		case width
		case hlsURL = "hls_url"
		case isGif = "is_gif"
		case scrubberMediaURL = "scrubber_media_url"
		case transcodingStatus = "transcoding_status"
	}
	
	public var heightRatio: CGFloat {
		return height / width
	}
}
