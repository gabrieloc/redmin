//
//  Encoding.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-29.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
	var formEncoded: Data? {
		return self
			.reduce(into: [String](), {
				let encodedValue = $1.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
				$0.append("\($1.key)=\(encodedValue)")
			})
			.joined(separator: "&")
			.data(using: .utf8)
	}
}
