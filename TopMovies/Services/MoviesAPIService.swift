//
//  MoviesAPIService.swift
//  TopMovies
//
//  Created by Maria José Sánchez Cairazco on 10/06/24.
//

import Foundation
import Alamofire

class MovieAPIService {
    func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(Constants.baseUrl)\(endpoint)?api_key=\(Constants.apiKey)"
        AF.request(url).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
