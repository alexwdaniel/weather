//
//  DaylightParser.swift
//  Weather
//
//  Created by Alexander Daniel on 2/12/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import Foundation

enum Scenes {
    case day
    case dusk
    case night
}

typealias RemainderConfig = (amount: String, icon: String, scene: Scenes)

class DaylightParser {
    
    var forecast: ForecastRequest
    
    init(_ forecast: ForecastRequest) {
        self.forecast = forecast
    }
    
    func parse() -> WeatherData {
        let today = self.forecast.daily.data[0]
        let tomorrow = self.forecast.daily.data[1]
        
        let config = self.remainderConfig(today: today, tomorrow: tomorrow)
        let weatherData = WeatherData(
            currentTemp: String(format: "%.0f", self.forecast.currently.temperature),
            amountOfDaylight: self.formatTimeInterval(start: today.sunriseTime, end: today.sunsetTime),
            remainingDaylight: config.amount,
            remainingDaylightIcon: config.icon,
            scene: config.scene,
            summary: today.summary,
            precipProbability: String(format: "%.0f", today.precipProbability),
            temperatureHigh: String(format: "%.0f", today.temperatureHigh),
            temperatureHighTime: self.timeFromTimestamp(TimeInterval(today.temperatureHighTime)),
            temperatureLow: String(format: "%.0f", today.temperatureLow),
            temperatureLowTime: self.timeFromTimestamp(TimeInterval(today.temperatureLowTime)),
            humidity: String(format: "%.0f", today.humidity),
            windSpeed: String(format: "%.0f", today.windSpeed),
            cloudCover: String(format: "%.0f", today.cloudCover)
        )
        
        return weatherData
    }
    
    private func timeFromTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }
    
    private func remainderConfig(today: DailyData, tomorrow: DailyData) -> RemainderConfig {
        let currentTime = Int(Date().timeIntervalSince1970)
        
        var remaining: RemainderConfig
        if currentTime > today.sunsetTime && currentTime < today.sunsetTime + 60 * 60 {
            remaining.amount = self.timeFromTimestamp(TimeInterval(tomorrow.sunriseTime))
            remaining.icon = "sunrise.fill"
            remaining.scene = Scenes.dusk
        }
        else if currentTime > today.sunsetTime || currentTime < today.sunriseTime {
            remaining.amount = self.timeFromTimestamp(TimeInterval(tomorrow.sunriseTime))
            remaining.icon = "sunrise.fill"
            remaining.scene = Scenes.night
        } else {
            remaining.amount = self.formatTimeInterval(start: currentTime, end: today.sunsetTime)
            remaining.icon = "sunset.fill"
            remaining.scene = Scenes.day
        }
        return remaining
    }
    
    
    private func formatTimeInterval(start: Int, end: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        
        return formatter.string(from: Double(end - start))!
    }
}
