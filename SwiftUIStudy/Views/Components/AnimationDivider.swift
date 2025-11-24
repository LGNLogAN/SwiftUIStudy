//
//  AnimationDivider.swift
//  FridgeMarket
//
//  Created by 무빈최 on 8/1/25.
//

import SwiftUI

struct AnimatedDivider: View {
    var isFocused: Bool
    var focusedColor: Color = .blue
    var focusedHeight: CGFloat = 2
    var unfocusedHeight: CGFloat = 1
    var paddingTopFocused: CGFloat = 4
    var paddingTopUnfocused: CGFloat = 0

    var body: some View {
        ZStack {
            Divider()
                .frame(height: isFocused ? focusedHeight : unfocusedHeight)
                .background(focusedColor)
                .opacity(isFocused ? 1 : 0)
                .padding(.top, isFocused ? paddingTopFocused : paddingTopUnfocused)

            Divider()
                .frame(height: isFocused ? focusedHeight : unfocusedHeight)
                .opacity(isFocused ? 0 : 1)
                .padding(.top, isFocused ? paddingTopFocused : paddingTopUnfocused)
        }
        .frame(height: max(focusedHeight + paddingTopFocused, unfocusedHeight + paddingTopUnfocused))
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
