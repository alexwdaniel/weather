//
//  ContentView.swift
//  Weather
//
//  Created by Alexander Daniel on 12/29/19.
//  Copyright © 2019 adaniel. All rights reserved.
//

import SwiftUI

let backgrounds = [
    Scenes.day: LinearGradient(gradient: Gradient(colors: [Color("Light Yellow"), Color("Light Blue")]), startPoint: UnitPoint(x: 0.2, y: 0.8), endPoint: UnitPoint(x: 0.9, y: 0.1)),
    Scenes.dusk: LinearGradient(gradient: Gradient(colors: [Color("Pink Orange"), Color("Purple")]), startPoint: UnitPoint(x: 0.1, y: 0.95), endPoint: UnitPoint(x: 0.75, y: 0.25)),
    Scenes.night: LinearGradient(gradient: Gradient(colors: [Color("Medium Blue"), Color("Dark Purple")]), startPoint: UnitPoint(x: 0.25, y: 0.85), endPoint: UnitPoint(x: 0.75, y: 0.35)),
]

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    @State private var isAnimating = false
    
    var body: some View {
        Group {
            ZStack {
                backgrounds[Scenes.day].edgesIgnoringSafeArea(.all)
                
                viewModel.weather.map({ weather in
                    Group {
                        backgrounds[weather.scene].edgesIgnoringSafeArea(.all)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(weather.currentTemp)°")
                                .font(Font.system(size: 72))
                                .bold()
                                .foregroundColor(.white)
                            HStack(alignment: .center) {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.white)
                                    .border(Color.red, width: 1)
                                Text(weather.amountOfDaylight)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 80.0, alignment: .trailing)
                                    .border(Color.red, width: 1)
                            }
                            HStack(alignment: .firstTextBaseline) {
                                Image(uiImage: UIImage(systemName: weather.remainingDaylightIcon)!.withRenderingMode(.alwaysTemplate).withTintColor(.white))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18.0)
                                    .foregroundColor(.white)
                                    .border(Color.red, width: 1)
                                Text(weather.remainingDaylight)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 80.0, alignment: .trailing)
                                    .border(Color.red, width: 1)
                            }
                            Spacer()
                            Text(viewModel.location ?? "")
                                .bold()
                                .foregroundColor(.white)
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding()
                    }
                })
                
                if viewModel.weather == nil {
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
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.viewModel.fetch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
