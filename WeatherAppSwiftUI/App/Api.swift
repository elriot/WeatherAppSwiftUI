//
//  Api.swift
//  WeatherAppSwiftUI
//
//  Created by SOOPIN KIM on 2024-08-19.
//

import Foundation

class Api {
    static let shared = Api()
    private init(){}

    enum Endpoint: String {
        case currentWeather = "/data/2.5/weather"
        case weeklyForecast = "/data/2.5/forecast"
        case citySearch = "/geo/1.0/direct"
    }
    
    let seattle: String = "CurrentWeather"
    let vancouver: String = "CurrentWeatherVancouver"

    
    // sample data
//    func fetchWeather(completion: @escaping (CurrentWeather?) -> Void) {
//        guard let path = Bundle.main.path(forResource: vancouver, ofType: "json") else {
//            completion(nil)
//            return
//        }
//        let url = URL(filePath: path)
//        let decoder = JSONDecoder()
//        do {
//            let data = try Data(contentsOf: url)
//            let decodeData = try decoder.decode(CurrentWeather.self, from: data)
//            completion(decodeData)
//        } catch {
//            print(error)
//            completion(nil)
//        }
//    }
    
    private func fetch<T: Decodable>(_ type: T.Type, _ request: URLRequest, completion: @escaping (T?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(type, from: data)
                completion(decodedData)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
    
    private func constructURL(for endpoint: Endpoint, _ lat: Double?, _ lon: Double?, _ city: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = endpoint.rawValue
        switch endpoint {
        case .currentWeather, .weeklyForecast:
            guard let lat, let lon else { return nil }
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: ApiInfo.key)
            ]
        case .citySearch:
            guard let city else { return nil }
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "limit", value: "\(10)"),
                URLQueryItem(name: "appid", value: ApiInfo.key)
            ]
        }
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        return request
    }
    
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping ((CurrentWeather?, WeeklyForecast?)) -> Void) {
        // call fetch x2 for CurrentWeather and WeeklyForecast objects
        // Construct URLRequest object x2 for the fetch function
        guard let currentWeather = constructURL(for: .currentWeather, lat, lon, nil), let weeklyForecast = constructURL(for: .weeklyForecast, lat, lon, nil) else {
            completion((nil, nil))
            return
        }
        
        var weather: CurrentWeather?
        var forecast: WeeklyForecast?
        
        let group = DispatchGroup()
        group.enter()
        fetch(CurrentWeather.self, currentWeather) { result in
            weather = result
            group.leave()
        }
        
        group.enter()
        fetch(WeeklyForecast.self, weeklyForecast) { result in
            forecast = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion((weather, forecast))
        }
    }
    
    func fetchLocation(city: String, completion: @escaping ([SearchLocation]?) -> Void){
        // Construct URLRequest object x1 for the fetch function for searching a location
        guard let search = constructURL(for: .citySearch, nil, nil, city) else {
            completion(nil)
            return
        }
        fetch([SearchLocation].self, search) { result in
            completion(result)
        }
    }
    
//    func fetchWeather(lat: Double, lon: Double, completion: @escaping(CurrentWeather?) -> Void){
//        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(ApiInfo.key)&units=metric"
//        let url = URL(string: urlStr)!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil, let data else {
//                completion(nil)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let decodeData = try decoder.decode(CurrentWeather.self, from: data)
//                completion(decodeData)
//            } catch {
//                print("Decoding error: \(error)")
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
    
//    func fetchForecast(lat: Double, lon: Double, completion: @escaping(WeeklyForecast?) -> Void){
//        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(ApiInfo.key)&units=metric"
//        let url = URL(string: urlStr)!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil, let data else {
//                completion(nil)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let decodeData = try decoder.decode(WeeklyForecast.self, from: data)
//                completion(decodeData)
//            } catch {
//                print("Decoding error: \(error)")
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
        
//    func fetchLocation(for city: String, completion:
//                                 @escaping ([SearchLocation]?) -> Void) {
//        let urlStr = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=\(ApiInfo.key)"
//        let url = URL(string: urlStr)!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil, let data else {
//                completion(nil)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let decodeData = try decoder.decode([SearchLocation].self, from: data)
//                completion(decodeData)
//            } catch {
//                print("Decoding error: \(error)")
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
    
    // sample data
    func fetchWeeklyForecast(completion: @escaping (WeeklyForecast?) -> Void) {
        guard let path = Bundle.main.path(forResource: "WeeklyForecast", ofType: "json") else {
            completion(nil)
            return
        }
        let url = URL(filePath: path)
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decodeData = try decoder.decode(WeeklyForecast.self, from: data)
            completion(decodeData)
        } catch {
            print(error)
            completion(nil)
        }
    }
    
    
    func fetchSample<T: Decodable>(_ type: T.Type, completion: @escaping (T?) -> Void) {
        let resource = getResourceName(type)
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            completion(nil)
            return
        }
        let url = URL(filePath: path)
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode(
                type,
                from: data)
            completion(decodedData)
        } catch {
            print(error)
            completion(nil)
        }
    }
    
    private func getResourceName<T>(_ type: T.Type) -> String {
        return switch type {
        case is CurrentWeather.Type:
            "CurrentWeatherVancouver"
        case is WeeklyForecast.Type:
            "WeeklyForecast"
        case is [SearchLocation].Type:
            "SearchLocation"
        default:
            ""
        }
    }
}

extension [WeeklyForecastList] {
    func getDailyForecasts() -> [DailyForecast] {
        var dailyForecasts: [DailyForecast] = []
        for item in self {
            guard let dt = item.dt?.toDay(), let low = item.main?.tempMin, let high = item.main?.tempMax else { continue }

            guard dailyForecasts.count > 0 else {
                let newDay = parse(using: item)
                dailyForecasts.append(newDay)
                continue
            }

            if dailyForecasts.last?.day == dt {
                let j = dailyForecasts.count - 1
                dailyForecasts[j].lows.append(low)
                dailyForecasts[j].highs.append(high)
            } else {
                let newDay = parse(using: item)
                dailyForecasts.append(newDay)
            }
        }
        return dailyForecasts
    }
    
    private func parse(using item: WeeklyForecastList) -> DailyForecast {
        var forecast = DailyForecast(day: item.dt!.toDay(), description: item.weather!.first?.main, dt_txt: item.dt_txt)
//        var forecast = DailyForecast(day: item.dt!.toDay(), description: item.weather!.first?.main)
        forecast.lows.append(item.main!.tempMin!)
        forecast.highs.append(item.main!.tempMax!)
        return forecast
    }
}
