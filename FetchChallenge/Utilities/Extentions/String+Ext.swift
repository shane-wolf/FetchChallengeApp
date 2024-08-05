//
//  String+Ext.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 7/30/24.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        return isEmpty || trimmingCharacters(in: .whitespaces) == ""
    }
}
