//
//  UIColor+Extension.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hex: String) {
            var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }

            guard cString.count == 6 else {
                // If the hexadecimal string is not 6 characters long, return nil
                return nil
            }

            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
}
