//
//  DetailView.swift
//  Weather
//
//  Created by Alex Daniel on 3/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var weather: WeatherData
    var location: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(location ?? "")
                .bold()
                .foregroundColor(.white)
            
            Text(weather.summary)
                .foregroundColor(.white)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("HIGH TEMP").textStyle(LabelStyle())
                    Text(weather.temperatureHigh).textStyle(DataStyle())
                    Text(weather.temperatureHighTime).textStyle(LabelStyle())
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("LOW TEMP").textStyle(LabelStyle())
                    Text(weather.temperatureLow).textStyle(DataStyle())
                    Text(weather.temperatureLowTime).textStyle(LabelStyle())
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("PRECIPITATION").textStyle(LabelStyle())
                    Text(weather.precipProbability).textStyle(DataStyle())
                }
            }.frame(maxWidth: .infinity)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("HUMIDITY").textStyle(LabelStyle())
                    Text(weather.humidity).textStyle(DataStyle())
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("WIND SPEED").textStyle(LabelStyle())
                    Text(weather.windSpeed).textStyle(DataStyle())
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("CLOUD COVER").textStyle(LabelStyle())
                    Text(weather.cloudCover).textStyle(DataStyle())
                }
            }.frame(maxWidth: .infinity)
            Spacer()
        }.padding()
    }
}
