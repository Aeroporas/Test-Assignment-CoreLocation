//
//  NetworkService.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation
import CoreLocation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    init() {}
    
    func sendSearchRequestForImage(location: CLLocation, completion: @escaping (Result<Photo, MyError>, _ location: CLLocation) -> Void) {
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard var URL = URL(string: "https://www.flickr.com/services/rest/") else {return}
        
        #warning("Flickr api_key in code")
        
        let URLParams = [
            "method": "flickr.photos.search",
            "format": "json",
            "api_key": "-",
            "per_page": "5",
            "lat": latitude,
            "lon": longitude,
            "nojsoncallback": "1"
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringCacheData
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = session.dataTask(with: request) {data, response, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        do {
                            let DTO = try JSONDecoder().decode(FlickrPhotoSearchResponse.self, from: data!)
                            if let photo = DTO.photos.photo.first {
                                completion(.success(photo), location)
                            } else {
                                completion(.failure(.noPhotoFoundError), location)
                            }
                            
                        } catch(let decodingError) {
                            completion(.failure(.system(decodingError)), location)
                        }
                        
                    } else {
                        // Failure
                        completion(.failure(.system(error!)), location)
                    }
                }
            }
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }
    
    func loadImageFromServer(location: CLLocation, photoDetails: Photo, completion: @escaping (Result<UIImage, MyError>, _ location: CLLocation) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "https://live.staticflickr.com/\(photoDetails.server)/\(photoDetails.id)_\(photoDetails.secret).jpg") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringCacheData
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = session.dataTask(with: request) {data, response, error in
                DispatchQueue.main.async {
                    if (error == nil) {
                        if let image = UIImage(data: data!) {
                            completion(.success(image), location)
                        } else {
                            completion(.failure(.imageDecodingError), location)
                        }
                    } else {
                        completion(.failure(.system(error!)), location)
                    }
                }
            }
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }
}

public enum MyError: Error {
    case noPhotoFoundError
    case imageDecodingError
    case system(Error)
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPhotoFoundError:
            return NSLocalizedString("No photos found for your location", comment: "noPhotoFoundError")
        case .imageDecodingError:
            return NSLocalizedString("Unable to show the image: the file recieved is corrupted.", comment: "corruptedImage")
        case .system(let error):
            return error.localizedDescription
        }
    }
}
