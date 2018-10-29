//
//  AuthenticationResult.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-29.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct AuthenticationResult {
	public enum Error: String {
		case access_denied
		case unsupported_response_type
		case invalid_scope
		case invalid_request
	}
	
	public var error: Error?
	public var code: String
	public var state: String
	
	public init?(url: URL) {
		guard
			let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
			let queryItems = components.queryItems
			else {
				return nil
		}
		
		let params = queryItems.reduce(into: [String: String](), { $0[$1.name] = $1.value ?? "" })
		
		guard let code = params["code"], let state = params["state"] else {
			return nil
		}
		self.code = code
		self.state = state
		
		if let rawError = params["error"] {
			error = Error(rawValue: rawError)
		}
	}
}
