//
//  ListingEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-11-04.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

protocol ListingEndpoint: Endpoint {
	var after: Fullname? { get }
	var limit: Int { get }
}

extension ListingEndpoint {
	
	public var queryItems: [URLQueryItem]? {
		var items = [
			URLQueryItem(name: "limit", value: String(limit)),
			]
		if let after = self.after {
			items.append(URLQueryItem(name: "after", value: after))
		}
		
		return items
	}
}
