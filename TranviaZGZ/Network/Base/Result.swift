//
//  Result.swift
//  TranviaZGZ
//
//  Created by Marcos on 15/12/21.
//

import Foundation

public enum Result<T> {
    case success(T)
    case error(Error)
}
