//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by SOOPIN KIM on 2024-07-29.
//

import UIKit

struct DailyForecast {
//    let img: UIImage
    let day: String
    let description: String?
    let dt_txt: String? // just for test
    
    var lows: [Double] = []
    var highs: [Double] = []
    var average: Double {
        return (lows.average() + highs.average()) / 2
    }
}
