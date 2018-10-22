//
//  TimeFormatting.swift
//  Redmin
//
//  Created by Gabriel O'Flaherty-Chan on 2018-10-22.
//  Copyright © 2018 gabrieloc. All rights reserved.
//

import Foundation

extension TimeInterval {
	var minutes: TimeInterval { return Unit.minute.to(self) }
	var minute: TimeInterval { return minutes }
	var hours: TimeInterval { return Unit.hour.to(self) }
	var hour: TimeInterval { return hours }
	var days: TimeInterval { return Unit.day.to(self) }
	var day: TimeInterval { return days }
	
	enum Unit: Double {
		case second = 1
		case minute = 60
		case hour = 3600
		case day = 86400
		
		func from(_ time: TimeInterval) -> TimeInterval {
			return time / rawValue
		}
		
		func to(_ time: TimeInterval) -> TimeInterval {
			return time * rawValue
		}
	}
	
	var floori: Int {
		return Int(floor(self))
	}
	
	public var prettyDuration: String {
		switch self {
		case 0..<1.minute:
			return "\(self.floori)s"
		case 1.minute..<1.hour:
			return "\(Unit.minute.from(self).floori)min"
		case 1.hour..<1.day:
			return "\(Unit.hour.from(self).floori)hr"
		case 1.day..<Double.infinity:
			return "\(Unit.day.from(self).floori)d"
		default:
			return "Just now"
		}
	}
}
