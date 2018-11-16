//
//  IdentityEndpoint.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-30.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

public struct IdentityEndpoint: Endpoint {
	public typealias R = User

	public var resourcePath: String {
		return "/api/v1/me"
	}
	
	public init() {
	}
}
