//
//  StringExt.swift
//  FortuneApp
//
//  Created by Николай Маторин on 28.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

extension String {
    init(key: LocalizationKeys) {
        self = NSLocalizedString(key.rawValue, comment: "")
    }
}
