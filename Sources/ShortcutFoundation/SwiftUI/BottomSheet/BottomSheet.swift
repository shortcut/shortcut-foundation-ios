//
//  BottomSheet.swift
//  ShortcutFoundation
//
//  Created by Darya Gurinovich on 07.01.22.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

public struct BottomSheet {
    public enum Options: Equatable {
        /// Sets the animation for opening and closing the BottomSheet.
        case animation(Animation)
        /// Changes the background of the BottomSheet
        case background(AnyView)
        /// The background to put above the BottomSheet superview
        case contentBackground(AnyView)
        /// Changes the corner radius of the BottomSheet.
        case cornerRadius(CGFloat)
        /// Changes the color of the drag indicator.
        case dragIndicatorColor(Color)
        /// Sets the padding to the BottomSheet inner elements
        case elementsPadding(EdgeInsets)
        /// Sets the maximum BottomSheet height
        case maxHeight(CGFloat)
        /// Hides the drag indicator.
        case noDragIndicator
        /// Dismisses the BottomSheet when swiped down.
        case swipeToDismiss
        /// Dismisses the BottomSheet when the background is tapped.
        case tapToDismiss
        /// Sets the top padding for the BottomSheet
        case topPadding(CGFloat)

        public static func == (lhs: BottomSheet.Options, rhs: BottomSheet.Options) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }

        public var rawValue: String {
            switch self {
            case .animation:
                return "animation"
            case .background:
                return "background"
            case .contentBackground:
                return "contentBackground"
            case .cornerRadius:
                return "cornerRadius"
            case .dragIndicatorColor:
                return "dragIndicatorColor"
            case .elementsPadding:
                return "elementsPadding"
            case .maxHeight:
                return "maxHeight"
            case .noDragIndicator:
                return "noDragIndicator"
            case .swipeToDismiss:
                return "swipeToDismiss"
            case .tapToDismiss:
                return "tapToDissmiss"
            case .topPadding:
                return "topPadding"
            }
        }
    }
}

/// An extension to encapsulate the BottomSheet options value retrieve
public extension Array where Element == BottomSheet.Options {
    var animation: Animation {
        for item in self {
            if case .animation(let customAnimation) = item {
               return customAnimation
            }
        }

        return Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1)
    }

    var background: AnyView {
        for item in self {
            if case .background(let customBackground) = item {
                return customBackground
            }
        }

        return Color.white.eraseToAnyView()
    }

    var contentBackground: AnyView {
        for item in self {
            if case .contentBackground(let customContentBackground) = item {
                return customContentBackground
            }
        }

        return Color.black.opacity(0.4).eraseToAnyView()
    }

    var cornerRadius: CGFloat {
        for item in self {
            if case .cornerRadius(let radius) = item {
                return radius
            }
        }

        return 24
    }

    var dragIndicatorColor: Color {
        for item in self {
            if case .dragIndicatorColor(let customDragIndicatorColor) = item {
                return customDragIndicatorColor
            }
        }

        return Color(UIColor.tertiaryLabel)
    }
    
    var elementsPadding: EdgeInsets {
        for item in self {
            if case .elementsPadding(let customElementsPadding) = item {
                return customElementsPadding
            }
        }

        return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    }

    var maxHeight: CGFloat {
        for item in self {
            if case .maxHeight(let maxHeight) = item {
                return maxHeight
            }
        }

        return .infinity
    }

    var noDragIndicator: Bool {
        self.contains(BottomSheet.Options.noDragIndicator)
    }

    var swipeToDismiss: Bool {
        self.contains(BottomSheet.Options.swipeToDismiss)
    }

    var tapToDismiss: Bool {
        self.contains(BottomSheet.Options.tapToDismiss)
    }

    var topPadding: CGFloat {
        for item in self {
            if case .topPadding(let topPadding) = item {
                return topPadding
            }
        }

        return 0
    }
}
