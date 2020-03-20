//
//  DaylightView.swift
//  Weather
//
//  Created by Alex Daniel on 3/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct DaylightView: View {
    var weather: WeatherData
    var location: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(weather.currentTemp)°")
                .font(Font.system(size: 72))
                .bold()
                .foregroundColor(.white)
            HStack(alignment: .center) {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.white)
                Text(weather.amountOfDaylight)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 80.0, alignment: .trailing)
            }
            HStack(alignment: .firstTextBaseline) {
                Image(uiImage: UIImage(systemName: weather.remainingDaylightIcon)!.withRenderingMode(.alwaysTemplate).withTintColor(.white))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18.0)
                    .foregroundColor(.white)
                Text(weather.remainingDaylight)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 80.0, alignment: .trailing)
            }
            Spacer()
            Text(location ?? "")
                .bold()
                .foregroundColor(.white)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding()
    }
}
