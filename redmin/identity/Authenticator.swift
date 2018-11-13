//
//  UserEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-28.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation
import SafariServices

public struct Authenticator {
	let clientID: String
	let scope: [String]
	let urlScheme: String
	let state: String
	
	public init(clientID: String, scope: [String], urlScheme: String, state: String) {
		self.clientID = clientID
		self.scope = scope
		self.urlScheme = urlScheme
		self.state = state
	}

	public var resourcePath: String {
		return "api/v1/authorize.compact"
	}
		
	var queryItems: [URLQueryItem] {
		let values = [
			"client_id": clientID,
			"response_type": "code",
			"state": state,
			"redirect_uri": urlScheme,
			"duration": "permanent",
			"scope": scope.joined(separator: " ")
		]
		
		return values.map { URLQueryItem(name: $0.key, value: $0.value) }
	}
	
	var url: URL {
		let url = NetworkService.shared.baseURL.appendingPathComponent(resourcePath)
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		components.queryItems = queryItems
		return components.url!
	}
	
	public func createController() -> UIViewController {
		return SFSafariViewController(url: url)
	}
	
	public func retrieveAccessToken(with code: String, _ completion: @escaping (EndpointResponse<TokenRefreshResponse>) -> Void) {
		let tokenRefresh = TokenRefreshEndpoint(
			grantType: .authorizationCode(code: code),
			redirectURI: urlScheme,
			clientID: clientID
		)
		NetworkService.shared.authentication = .authorized(clientID: clientID)
		tokenRefresh.request(completion)
	}
}
