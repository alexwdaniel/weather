//
//  LoadingView.swift
//  Weather
//
//  Created by Alex Daniel on 3/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        Image(systemName: "sun.max.fill")
            .font(.system(size: 24))
            .foregroundColor(.white)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            .onAppear {
                self.isAnimating = true
            }
    }
}
