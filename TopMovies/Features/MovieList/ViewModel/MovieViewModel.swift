//
//  MovieViewModel.swift
//  TopMovies
//
//  Created by Maria José Sánchez Cairazco on 9/06/24.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var availableLanguages: [String: String] = [:]

    private let apiService = MovieAPIService()

    func fetchMovies(for segment: Int) {
        let endpoint: String
        switch segment {
        case 0:
            endpoint = "movie/popular"
        case 1:
            endpoint = "movie/top_rated"
        default:
            return
        }

        apiService.fetchMovies(endpoint: endpoint) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.filteredMovies = movies
                    self.extractLanguages(from: movies)
                }
            case .failure(let error):
                print("There was an error fetching the movies: \(error.localizedDescription)")
            }
        }
    }
    
    func filterMovies(adult: Bool? = nil, language: String? = nil, minVote: Double? = nil, maxVote: Double? = nil) {
            filteredMovies = movies.filter { movie in
                // Adult filter
                let matchesAdult = adult == nil || movie.adult == adult
                
                // Language filter
                let lowercasedLanguage = language?.lowercased()
                let lowercasedMovieLanguage = movie.originalLanguage.lowercased()
                let matchesLanguage = lowercasedLanguage == nil || lowercasedMovieLanguage == lowercasedLanguage
                
                // Vote filter
                let matchesVote = (minVote == nil || movie.voteAverage >= minVote!) && (maxVote == nil || movie.voteAverage <= maxVote!)
                
                return matchesAdult && matchesLanguage && matchesVote
            }
        }

    func searchMovies(by title: String) {
        searchResults = movies.filter { $0.title.lowercased().contains(title.lowercased()) }
    }
    
    func extractLanguages(from movies: [Movie]) {
        var languages = [String: String]()
        for movie in movies {
            let code = movie.originalLanguage
            if let languageName = Locale.current.localizedString(forLanguageCode: code) {
                languages[code] = languageName
            }
        }
        availableLanguages = languages
    }
}
