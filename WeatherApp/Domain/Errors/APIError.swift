//
//  APIError.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 28/12/2025.
//

import Foundation

enum APIError: Error ,LocalizedError{
    
    case urlError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self{
        case .urlError(let error):
            return error.localizedDescription
            
        case .unknown(let error):
            return "Unknown Error occured: \(error.localizedDescription)"
            
            
        }
        
    }
}

