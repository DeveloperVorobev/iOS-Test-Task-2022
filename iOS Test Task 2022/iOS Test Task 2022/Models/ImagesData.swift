//
//  ImageData.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 14.10.2022.
//

import Foundation

struct ImagesData: Codable{
    let images_results: [OneImageData]
}

struct OneImageData: Codable {
    let position: Int
    let original: String
    let original_width: Int
    let original_height: Int
}


