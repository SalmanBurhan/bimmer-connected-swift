//
//  UIFriendlyRawRepresentable.swift
//
//
//  Created by Salman Burhan on 11/17/23.
//

import Foundation

public protocol UIFriendlyRawRepresentable: CaseIterable, Equatable, RawRepresentable {
    associatedtype RawValue = String
    var value: RawValue { get }
    var friendlyValue: RawValue { get }
}

extension UIFriendlyRawRepresentable {
    public var rawValue: RawValue {
        return self.value
    }
}
