//
//  Verification.swift
//  Signup
//
//  Created by seongha shin on 2022/03/31.
//

import Foundation

class Verification<T: BaseValidate> {
    func check(text: String) -> ValidateResult {
        T.verification(text: text)
    }
}
