//
//  MovieViewModelTests.swift
//  TopMoviesTests
//
//  Created by Maria José Sánchez Cairazco on 10/06/24.
//

import XCTest
@testable import TopMovies

class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel?
    var mockAPIService: MockMovieAPIService?

    override func setUp() {
        super.setUp()
        mockAPIService = MockMovieAPIService()
        
        guard let unwrapMockAPIService = mockAPIService else { return }
        viewModel = MovieViewModel(apiService: unwrapMockAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchPopularMovies() {
        guard let viewModel = viewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        let expectation = self.expectation(description: "FetchPopularMovies")
        viewModel.fetchMovies(for: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.movies.count, 2)
            XCTAssertEqual(viewModel.movies.first?.title, "Mock Movie 1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFilterAdultMovies() {
        guard let viewModel = viewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        viewModel.fetchMovies(for: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.filterMovies(adult: true)
            XCTAssertEqual(viewModel.filteredMovies.count, 1)
            XCTAssertEqual(viewModel.filteredMovies.first?.title, "Mock Movie 2")
        }
    }
    
    func testFilterLanguageMovies() {
        guard let viewModel = viewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        viewModel.fetchMovies(for: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.filterMovies(language:"en")
            XCTAssertEqual(viewModel.filteredMovies.count, 1)
            XCTAssertEqual(viewModel.filteredMovies.first?.title, "Mock Movie 1")
        }
    }
    
    func testFilterRatingMovies() {
        guard let viewModel = viewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        viewModel.fetchMovies(for: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.filterMovies(minVote: 8.0, maxVote: 10.0)
            XCTAssertEqual(viewModel.filteredMovies.count, 1)
            XCTAssertEqual(viewModel.filteredMovies.first?.title, "Mock Movie 2")
        }
    }

    func testSearchMovies() {
        guard let viewModel = viewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        viewModel.fetchMovies(for: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.searchMovies(by: "Mock Movie")
            XCTAssertEqual(self.viewModel?.searchResults.count, 2)
        }
    }
}
