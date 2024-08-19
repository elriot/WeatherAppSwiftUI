//
//  Extensions.swift
//  WeatherAppSwiftUI
//
//  Created by SOOPIN KIM on 2024-08-19.
//

import Foundation

extension [Double] {
    func average() -> Double {
        var total: Double = 0
        var count: Double = 0
        for num in self {
            total += num
            count += 1
        }
        return total / count
    }
}

extension Int {
    func toDay() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        return date.formatted(Date.FormatStyle().weekday(.abbreviated))
    }
    
    func toHour() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("h:mm")
        
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let date = Date(timeIntervalSince1970: Double(self))
        return formatter.string(from: date)
    }
}
//
//extension UIViewController {
//    func pushVC(_ vc: UIViewController?){
//        guard let newVC = vc else { return }
//        navigationController?.pushViewController(newVC, animated: true)
//    }
//    
//    func popVC(){
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//extension UIColor {
//    static let cloudColor = UIColor(named: "CloudyBackground")!
//    static let rainColor = UIColor(named: "RainyBackground")!
//    static let snowColor = UIColor(named: "SnowyBackground")!
//    static let sunColor = UIColor(named: "SunnyBackground")!
//    static let windColor = UIColor(named: "WindyBackground")!
//}
//
//extension UIViewController {
//    func setBackgroundColor(_ weather: CurrentWeather?){
//        guard let weather, let description = weather.weather.first?.main else {
//            resetBackgroundColor()
//            return
//        }
//        
//        let weatherType = WeatherType(description)
//        view.backgroundColor = weatherType.background
//        navigationController?.navigationBar.barTintColor = weatherType.background
//        tabBarController?.tabBar.barTintColor = weatherType.background
//        tabBarController?.tabBar.tintColor = weatherType.tint
//    }
//    
//    func resetBackgroundColor() {
//        view.backgroundColor = .white
//        navigationController?.navigationBar.barTintColor = .white
//        tabBarController?.tabBar.barTintColor = .white
//        tabBarController?.tabBar.tintColor = .systemBlue
//    }
//}
//
