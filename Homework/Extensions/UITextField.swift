//
//  UITextField.swift
//  Homework
//
//  Created by talha.sahin on 19.06.2024.
//

import Foundation
import UIKit

extension UITextField {
    var checkIsEmpty: Bool {
        guard let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return true
        }
        return false
    }
}
