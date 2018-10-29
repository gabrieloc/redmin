//
//  TokenRefreshEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-29.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct TokenRefreshResponse: Decodable {
	public let accessToken: String
	public let tokenType: String
	public let expiresIn: TimeInterval
	public let scope: String
	public let refreshToken: String
	
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
		case expiresIn = "expires_in"
		case scope
		case refreshToken = "refresh_token"
	}
}

public struct TokenRefreshEndpoint: Endpoint {
	public typealias R = TokenRefreshResponse
	
	public enum GrantType {
		case authorizationCode(code: String)
		case refreshToken
		
		var rawValue: String {
			switch self {
			case .authorizationCode:
				return "authorization_code"
			case .refreshToken:
				return "refresh_token"
			}
		}
	}
	
	let grantType: GrantType
	let redirectURI: String
	let clientID: String
	
	public init(grantType: GrantType, redirectURI: String, clientID: String) {
		self.grantType = grantType
		self.redirectURI = redirectURI
		self.clientID = clientID
	}
	
	var body: [String: String] {
		var body = [
			"grant_type": grantType.rawValue,
			"redirect_uri": redirectURI
		]
		if case GrantType.authorizationCode(let code) = grantType {
			body["code"] = code
		}
		return body
	}
	
	public var method: Method {
		return .post(body: body)
	}
	
	public var resourcePath: String {
		return "api/v1/access_token"
	}
	
	public var contentType: ContentType {
		return .form
	}
}
