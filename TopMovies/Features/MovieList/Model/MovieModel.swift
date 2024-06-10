//
//  MovieModel.swift
//  TopMovies
//
//  Created by Maria José Sánchez Cairazco on 9/06/24.
//

import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let adult: Bool
    let originalLanguage: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
    }
}
