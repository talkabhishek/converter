//
//  Injectable.swift
//  Converter
//
//  Created by abhisheksingh03 on 26/04/22.
//

import Foundation

protocol Injectable {
    associatedtype Dependencies
    var dependencies: Dependencies! { get set }
}

