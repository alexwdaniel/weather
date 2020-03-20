//
//  PageView.swift
//  PageView
//
//  Created by Alexander Daniel on 3/8/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct PageView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.content.frame(height: geometry.size.height)
            }
            .frame(height: geometry.size.height, alignment: .top)
            .offset(y: -CGFloat(self.currentIndex) * geometry.size.height)
            .offset(y: self.translation)
            .animation(.interactiveSpring())
            .contentShape(Rectangle())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let offset = value.translation.height / geometry.size.height
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}
