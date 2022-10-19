//
//  ImagesNetworkManager.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 14.10.2022.
//

protocol ImageNetworkDelagate{
    func didUpdateImages(_ imagesNetworkManager: ImagesNetworkManager, images: [OneImageData])
    func didFailWithError(_ error: Error)
}


import UIKit
struct ImagesNetworkManager {
    var imagesDataURL = "https://www.apple.com"
    var region: String?

    
    var delegate: ImageNetworkDelagate?
    
    mutating func feachImage(q: String){

        var urlString = "https://serpapi.com/search.json?q=\(q)&tbs=itp:photos&tbm=isch&ijn=0&device=mobile&ijn=0&serp_api_key=\(K.apiKey)"
        imagesDataURL = urlString
        if region != nil  && region != "nil"{
            urlString += "&gl=\(region!)"
        }
       
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) else {print("error1");return}
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url) {data, urlresponse, error in
            guard error == nil else {
                delegate?.didFailWithError(error!)
                return}
            guard let safeData = data else {print("error2");return}
            
            if let images = self.parseJSON(safeData){
                self.delegate?.didUpdateImages(self, images: images)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ imagesData: Data) -> [OneImageData]?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImagesData.self, from: imagesData)
            let result = decodedData.images_results
            
            return result
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func requestForImage(imagesForNet: OneImageData) -> UIImage? {
        
        let url = URL(string: imagesForNet.original)
        
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            return image
        }catch let error as NSError {
            print(error)
            return nil
        }
    }
}
