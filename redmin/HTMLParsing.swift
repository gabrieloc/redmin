//
//  HTMLParsing.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-22.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

extension String {
	public func htmlAttributedString(font: UIFont) -> NSAttributedString {
		let fontFamily = font.familyName == UIFont.systemFont(ofSize: 14).familyName ? "'-apple-system', 'HelveticaNeue', 'sans-serif'" : font.familyName
		let format = "<span style=\"font-family: \(fontFamily); font-size: \(font.pointSize)\">%@</span>"
		let formatted = String(format: format, trimmingCharacters(in: .whitespacesAndNewlines))
		
		guard
			let data = formatted.data(using: String.Encoding.utf16, allowLossyConversion: false),
			let attributedString = try? NSMutableAttributedString(
				data: data,
				options: [
					.documentType: NSAttributedString.DocumentType.html,
					.characterEncoding: String.Encoding.utf8.rawValue
				],
				documentAttributes: nil)
			else {
				return NSAttributedString(string: self)
		}
		if let lastCharacter = attributedString.string.last, lastCharacter == "\n" {
			attributedString.deleteCharacters(in: NSRange(location: attributedString.length-1, length: 1))
		}
		return attributedString
	}
}
