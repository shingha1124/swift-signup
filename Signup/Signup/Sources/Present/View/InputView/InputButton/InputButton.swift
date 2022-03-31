//
//  InputButton.swift
//  Signup
//
//  Created by seongha shin on 2022/03/29.
//

import Foundation
import UIKit
import Combine

protocol InputButtonField {
    var publisher: AnyPublisher<Void, Never> { get }
    var title: String { get }
    var view: UIView { get }
    func addAction(_ action: UIAction)
    func setMessage(_ message: String)
}
