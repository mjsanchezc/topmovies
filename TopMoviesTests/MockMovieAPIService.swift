//
//  MockMovieAPIService.swift
//  TopMoviesTests
//
//  Created by Maria José Sánchez Cairazco on 10/06/24.
//

import Foundation

class MockMovieAPIService: MovieAPIService {
    override func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if let url = Bundle(for: type(of: self)).url(forResource: "MockMovies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "MockMovieAPIService", code: -1, userInfo: nil)))
        }
    }
}
