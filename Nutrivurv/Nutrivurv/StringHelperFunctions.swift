//
//  StringHelperFunctions.swift
//  Nutrivurv
//
//  Created by Dillon on 6/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}