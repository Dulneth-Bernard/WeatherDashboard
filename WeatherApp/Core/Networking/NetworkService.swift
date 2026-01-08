//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 16/12/2025.
//

import Foundation

protocol NetworkService : Sendable{
    func fetch<T:Decodable>(urlString: String) async throws -> T
}
