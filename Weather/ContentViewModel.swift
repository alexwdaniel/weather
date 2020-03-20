//
//  ContentViewModel.swift
//  Weather
//
//  Created by Alexander Daniel on 1/1/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    var temperature: Double
}

struct DailyDataBlock: Codable {
    let data: [DailyData]
    let summary: String
    let icon: String
}

struct DailyData: Codable {
    let time: Int
    let sunriseTime: Int
    let sunsetTime: Int
    let summary: String
    let precipProbability: Float
    let temperatureHigh: Float
    let temperatureHighTime: Int
    let temperatureLow: Float
    let temperatureLowTime: Int
    let humidity: Float
    let windSpeed: Float
    let cloudCover: Float
}

struct ForecastRequest: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let daily: DailyDataBlock
}

struct WeatherData {
    let currentTemp: String
    let amountOfDaylight: String
    let remainingDaylight: String
    let remainingDaylightIcon: String
    var location: String?
    let scene: Scenes
    let summary: String
    let precipProbability: String
    let temperatureHigh: String
    let temperatureHighTime: String
    let temperatureLow: String
    let temperatureLowTime: String
    let humidity: String
    let windSpeed: String
    let cloudCover: String
}

class ContentViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var location: String?
    
    let lm = LocationManager()
    var locationCancellable: AnyCancellable?
    var placemarkCancellable: AnyCancellable?
    var requestCancellable: AnyCancellable?
    
    init() {
        locationCancellable = lm.$location.sink { (location) in
            if let location = location {
                self.requestCancellable?.cancel()
                self.load(location: location)
            }
        }
        
        placemarkCancellable = lm.$placemark.sink { (placemark) in
            if let city = placemark?.locality, let state = placemark?.administrativeArea {
                DispatchQueue.main.async {
                    self.location = "\(city), \(state)"
                }
            }
        }
    }
    
    func fetch() {
        guard let location = lm.location else {
            return
        }
        self.load(location: location)
    }
    
    func load (location: CLLocation) {
        let url = URL(string: "https://api.darksky.net/forecast/4708c217fce375dae305b3f9ad72d6cb/\(location.latitude),\(location.longitude)")!
        requestCancellable = URLSession(configuration: .default).dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ForecastRequest.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("--> fetch finished.")
                }
            }, receiveValue: { decoded in
                let parser = DaylightParser.init(decoded)
                let weatherData = parser.parse()
                
                DispatchQueue.main.async {
                    self.weather = weatherData
                }
            })
    }
}
