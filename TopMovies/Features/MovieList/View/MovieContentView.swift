//
//  MovieContentView.swift
//  TopMovies
//
//  Created by Maria José Sánchez Cairazco on 9/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieContentView: View {
    @ObservedObject var movieViewModel = MovieViewModel()

    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var isFilterViewPresented = false
    
    @State private var filterAdult: Bool? = nil
    @State private var filterLanguage: String? = nil
    @State private var filterMinVote: Double? = nil
    @State private var filterMaxVote: Double? = nil

    var body: some View {
        NavigationView {
            VStack {
                Picker("Movies", selection: $selectedSegment) {
                    Text("Popular").tag(0)
                    Text("Top Rated").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedSegment) {
                    movieViewModel.fetchMovies(for: selectedSegment)
                }
                .onAppear {
                    movieViewModel.fetchMovies(for: selectedSegment)
                }
                
                HStack {
                    TextField("Search by title", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        isFilterViewPresented.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .padding(.trailing)
                    }
                    .sheet(isPresented: $isFilterViewPresented) {
                        MovieFilterContentView(
                            adult: $filterAdult,
                            language: $filterLanguage,
                            minVote: $filterMinVote,
                            maxVote: $filterMaxVote,
                            applyFilters: applyFilters
                        )
                    }
                }

                List(searchText.isEmpty ? movieViewModel.filteredMovies : movieViewModel.searchResults) { movie in
                    HStack {
                        if let posterPath = movie.posterPath {
                            WebImage(url: URL(string: "\(Constants.imageBaseUrl)\(posterPath)"))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.overview)
                                .font(.subheadline)
                                .lineLimit(3)
                        }
                    }
                }
            }
            .navigationTitle("Movies")
            .onChange(of: searchText) {
                movieViewModel.searchMovies(by: searchText)
            }
        }
    }
    
    private func applyFilters() {
        movieViewModel.filterMovies(
            adult: filterAdult,
            language: filterLanguage,
            minVote: filterMinVote,
            maxVote: filterMaxVote
        )
    }
}

#Preview {
    MovieContentView()
}
