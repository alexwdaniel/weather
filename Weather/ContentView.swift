//
//  ContentView.swift
//  Weather
//
//  Created by Alexander Daniel on 12/29/19.
//  Copyright © 2019 adaniel. All rights reserved.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .lineSpacing(8)
            .foregroundColor(.primary)
    }
}

struct DataStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
    }
}

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
    }
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

let backgrounds = [
    Scenes.day: LinearGradient(gradient: Gradient(colors: [Color("Light Yellow"), Color("Light Blue")]), startPoint: UnitPoint(x: 0.2, y: 0.8), endPoint: UnitPoint(x: 0.9, y: 0.1)),
    Scenes.dusk: LinearGradient(gradient: Gradient(colors: [Color("Pink Orange"), Color("Purple")]), startPoint: UnitPoint(x: 0.1, y: 0.95), endPoint: UnitPoint(x: 0.75, y: 0.25)),
    Scenes.night: LinearGradient(gradient: Gradient(colors: [Color("Medium Blue"), Color("Dark Purple")]), startPoint: UnitPoint(x: 0.25, y: 0.85), endPoint: UnitPoint(x: 0.75, y: 0.35)),
]

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()    
    @State private var currentPage = 0
    
    var body: some View {
        Group {
            ZStack {
                backgrounds[Scenes.day].edgesIgnoringSafeArea(.all)
                
                viewModel.weather.map({ weather in
                    Group {
                        backgrounds[weather.scene].edgesIgnoringSafeArea(.all)
                        
                        PageView(pageCount: 3, currentIndex: $currentPage) {
                            DaylightView(weather: weather, location: viewModel.location)
                            DetailView(weather: weather, location: viewModel.location)
                        }
                    }
                })
                
                if viewModel.weather == nil {
                    LoadingView()
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.viewModel.fetch()
        }.statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
