//
//  NavigationLink+Extension.swift
//  ShortcutFoundation
//
//  Created by Karl Söderberg on 2022-01-17.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.


import SwiftUI

public extension View {
    
    func navigate<Destination: View>(
        isActive: Binding<Bool>,
        destination: Destination?
    ) -> some View {
        background(
            NavigationLink(
                destination: destination,
                isActive: isActive,
                label: EmptyView.init
            )
            .hidden()
        )
    }
    
    func navigate<Item, Destination: View>(
        item: Binding<Item?>,
        destination: (Item) -> Destination
    ) -> some View {
        navigate(
            isActive: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            destination: Group {
                if let item = item.wrappedValue {
                    destination(item)
                }
            }
        )
    }
}
