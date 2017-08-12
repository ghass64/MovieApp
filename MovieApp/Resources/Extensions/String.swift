//
//  StringExtension.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import Foundation

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
