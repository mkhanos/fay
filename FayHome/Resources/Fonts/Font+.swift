//
//  Font+.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import SwiftUI

extension Font {
    enum FontStyle: String {
        case title
        case smallBodyBold
        case captionMedium
    }
    
    enum ManropeFont: String {
        case extralight = "Manrope-ExtraLight"
        case light = "Manrope-Light"
        case regular = "Manrope-Regular"
        case medium = "Manrope-Medium"
        case semibold = "Manrope-SemiBold"
        case bold = "Manrope-Bold"
        case extrabold = "Manrope-ExtraBold"
    }
    
    static func manrope(_ type: ManropeFont, size: CGFloat = 14) -> Font {
        return .custom(type.rawValue, size: size)
    }
    
    static func manrope(_ style: FontStyle) -> Font {
        switch style {
        case .title:
            return .custom(ManropeFont.extrabold.rawValue, size: 26, relativeTo: .title)
        case .smallBodyBold:
            return .custom(ManropeFont.bold.rawValue, size: 16, relativeTo: .body)
        case .captionMedium:
            return .custom(ManropeFont.medium.rawValue, size: 14, relativeTo: .caption)
        }
    }
}
