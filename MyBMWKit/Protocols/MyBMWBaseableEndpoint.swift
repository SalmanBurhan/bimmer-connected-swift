//
//  MyBMWBaseableEndpoint.swift
//  
//
//  Created by Salman Burhan on 11/17/23.
//

import Foundation

public protocol MyBMWBaseableEndpoint: Equatable {
    static var base: Self { get }
    var path: String { get }
}
