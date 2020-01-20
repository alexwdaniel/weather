//
//  ContentView.swift
//  Weather
//
//  Created by Alexander Daniel on 12/29/19.
//  Copyright © 2019 adaniel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        Group {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                
                if viewModel.weather != nil {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.weather!.currentTemp)°").font(.system(size: 72)).bold()
                        Text("\(viewModel.weather!.amountOfDaylight) of daylight.")
                        Text("\(viewModel.weather!.remainingDaylight) remaining.")
                        Spacer()
                        Text(viewModel.location ?? "").bold()
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding()
                } else {
                    Text("Loading...")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
