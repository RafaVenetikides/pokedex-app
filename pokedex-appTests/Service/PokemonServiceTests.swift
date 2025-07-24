//
//  PokemonServiceTests.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 24/07/25.
//

import XCTest
@testable import pokedex_app

final class PokemonServiceTests: XCTestCase {
    var sut: PokemonService!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = PokemonService(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPokemonList_whenResponseIsSuccessful_shouldReturnPokemons() {
        let expectation = XCTestExpectation(description: "Fetch Pokemon list")
        let mockResponse = createMockPokemonListResponse()
        mockNetworkClient.result = .success(mockResponse)
        
        sut.fetchPokemonList { result in
            switch result {
            case .success(let pokemons):
                XCTAssertEqual(pokemons.count, 2)
                XCTAssertEqual(pokemons[0].name, "Bulbasaur")
                XCTAssertEqual(pokemons[1].name, "Ivysaur")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        XCTAssertEqual(mockNetworkClient.lastFetchedURL, "https://pokeapi.co/api/v2/pokemon?limit=151")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonList_whenResponseFailt_shouldReturnError() {
        let expectation = XCTestExpectation(description: "Fetch Pokemon list fails")
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockNetworkClient.result = .failure(expectedError)
        
        sut.fetchPokemonList { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "TestError")
                XCTAssertEqual(error.code, 500)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonDetail_whenResponseIsSuccessful_shouldReturnPokemonDetail() {
        let expectation = XCTestExpectation(description: "Fetch Pokemon detail")
        let mockResponse = createMockPokemonDetailResponse()
        mockNetworkClient.result = .success(mockResponse)
        let testURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")!
        
        sut.fetchPokemonDetail(from: testURL) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.name, "bulbasaur")
                XCTAssertEqual(detail.id, 1)
                XCTAssertEqual(detail.height, 0.7)
                XCTAssertEqual(detail.weight, 6.9)
                XCTAssertEqual(detail.types, [.grass])
                XCTAssertEqual(detail.imageUrl, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        XCTAssertEqual(mockNetworkClient.lastFetchedURL, "https://pokeapi.co/api/v2/pokemon/1")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPokemonDetail_whenResponseFails_shouldReturnError() {
        let expectation = XCTestExpectation(description: "Fetch Pokemon detail fails")
        let expectedError = NSError(domain: "TestError", code: 404, userInfo: nil)
        mockNetworkClient.result = .failure(expectedError)
        let testURL = URL(string: "https://pokeapi.co/api/v2/pokemon/999")!
        
        sut.fetchPokemonDetail(from: testURL) { result in
            switch result {
                case .success:
                    XCTFail("Expected failure but got success")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "TestError")
                XCTAssertEqual(error.code, 404)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func createMockPokemonListResponse() -> PokemonListResponse {
        let pokemon1 = PokemonResponse(name: "bulbasaur", pokemonUrl: "https://pokeapi.co/api/v2/pokemon/1/")
        let pokemon2 = PokemonResponse(name: "ivysaur", pokemonUrl: "https://pokeapi.co/api/v2/pokemon/2/")
        return PokemonListResponse(results: [pokemon1, pokemon2])
    }
    
    private func createMockPokemonDetailResponse() -> PokemonDetailResponse {
        return PokemonDetailResponse(
            name: "bulbasaur",
            height: 7,
            weight: 69,
            id: 1,
            types: [
                TypeElementResponse(
                    type: TypeInfoResponse(name: "grass")
                )
            ]
        )
    }
}
