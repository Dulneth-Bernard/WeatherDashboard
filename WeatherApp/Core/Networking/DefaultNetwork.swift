


import Foundation


struct DefaultNetwork: NetworkService{
    private let decoder : JSONDecoder
    private let session : URLSession
    
    init(decoder: JSONDecoder = JSONDecoder(), session: URLSession = .shared) {
        self.decoder = decoder
        self.session = session
    }
    
    func fetch<T:Decodable>(urlString: String, type: T.Type) async throws -> T{
        
        guard let url =  URL(string:urlString ) else{
            throw WeatherMapError.invalidURL(urlString)
        }
        
        do{
            let (data,response) = try await session.data(from: url)
            
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else{
                throw WeatherMapError.invalidResponse(statusCode: 200)
                
            }
            
            let responseData = try decoder.decode(T.self, from: data)
            
            return responseData
        }
        catch let error as DecodingError{
            throw WeatherMapError.decodingError(error)
        }
        catch let error as URLError{
            throw APIError.urlError(error)
        }
        catch let error {
            throw APIError.unknown(error)
        }
        
    }
    
    
    
}

