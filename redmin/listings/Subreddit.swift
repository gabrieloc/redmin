//
//  Subreddit.swift
//  redmin-client
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-27.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct Subreddit: Resource, Codable, Equatable {
	public var title: String
	public var displayName: String
	public var advertiserCategory: String?
	
	private var rawDescription: String?
	private var iconURL: URL?
	private var iconSize: [Int]?
	private var bannerURL: URL?
	private var bannerSize: [Int]?
	
	public var icon: Image?
	public var banner: Image?
	public var description: NSAttributedString?
	
	enum CodingKeys: String, CodingKey {
		case advertiserCategory = "advertiser_category"
		case title
		case rawDescription = "public_description_html"
		case displayName = "display_name"
		case iconURL = "icon_img"
		case iconSize = "icon_size"
		case bannerURL = "banner_img"
		case bannerSize = "banner_size"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		advertiserCategory = try? container.decode(String.self, forKey: .advertiserCategory)
		title = try container.decode(String.self, forKey: .title)
		displayName = try container.decode(String.self, forKey: .displayName)

		rawDescription = try? container.decode(String.self, forKey: .rawDescription)
		description = rawDescription?.htmlAttributedString(font: UIFont.systemFont(ofSize: 14))

		iconURL = try? container.decode(URL.self, forKey: .iconURL)
		iconSize = try? container.decode([Int].self, forKey: .iconSize)
		icon = {
			guard let url = iconURL, let size = iconSize, size.count == 2 else {
				return nil
			}
			return Image(url: url, size: CGSize(width: size[0], height: size[1]))
		}()

		bannerURL = try? container.decode(URL.self, forKey: .bannerURL)
		bannerSize = try? container.decode([Int].self, forKey: .bannerSize)
		banner = {
			guard let url = bannerURL, let size = bannerSize, size.count == 2 else {
				return nil
			}
			return Image(url: url, size: CGSize(width: size[0], height: size[1]))
		}()
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(rawDescription, forKey: .rawDescription)
		try container.encode(iconURL, forKey: .iconURL)
		try container.encode(iconSize, forKey: .iconSize)
		try container.encode(bannerURL, forKey: .bannerURL)
		try container.encode(bannerSize, forKey: .bannerSize)
	}
}
