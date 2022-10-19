//
//  ImageModel.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 14.10.2022.
//

import Foundation

struct ImageModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
}
