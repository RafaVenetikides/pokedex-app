//
//  PokemonDetailViewModelTests.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 24/07/25.
//

import XCTest
@testable import pokedex_app

final class PokemonDetailViewModelTests: XCTestCase {
    
    var mockService: MockPokemonService!
    var mockDelegate: MockPokemonDetailDelegate!
    var mockRepository: MockFavoritePokemonRepository!
    var sut: PokemonDetailViewModel!
    var mockURL: URL!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        mockDelegate = MockPokemonDetailDelegate()
        mockURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")
        mockRepository = MockFavoritePokemonRepository()
        
        sut = PokemonDetailViewModel(
            url: mockURL,
            service: mockService,
            repository: mockRepository
        )
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        mockService = nil
        mockDelegate = nil
        mockRepository = nil
        sut = nil
        mockURL = nil
        super.tearDown()
    }
    
    func test_fetchPokemonDetail_whenResponseIsSuccessful_shouldLoadWithCorrectPokemon() {
        
        let expectedPokemon = createSamplePokemon()
        mockService.pokemonDetailResult = .success(expectedPokemon)
        mockRepository.containsToBeReturned = true
        
        sut.fetchPokemonDetail()
        
        XCTAssertTrue(mockDelegate.didLoadDetailCalled)
        XCTAssertFalse(mockDelegate.didFailCalled)
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Bulbasaur")
        XCTAssertEqual(mockDelegate.loadedDetail?.id, 1)
        XCTAssertTrue(mockDelegate.loadedIsFavorited)
    }
    
    func test_fetchPokemonDetail_whenResponseFails_shouldNotifyDelegateWithError() {
        
        enum TestError: Error {
            case networkError
        }
        mockService.pokemonDetailResult = .failure(TestError.networkError)
        
        sut.fetchPokemonDetail()
        
        XCTAssertTrue(mockDelegate.didFailCalled)
        XCTAssertFalse(mockDelegate.didLoadDetailCalled)
        XCTAssertNotNil(mockDelegate.failedWithError)
    }
    
    func test_fetchPokemonDetail_whenURLIsNil_shouldNotifyDelegateWithError() {
        sut = PokemonDetailViewModel(
            url: nil,
            service: mockService,
            repository: mockRepository
        )
        sut.delegate = mockDelegate
        
        sut.fetchPokemonDetail()
        
        XCTAssertFalse(mockDelegate.didLoadDetailCalled)
        XCTAssertTrue(mockDelegate.didFailCalled)
    }
    
    func test_toggleFavorite_whenPokemonIsNotFavorited_shouldAddToFavorites() {
        let pokemon = createSamplePokemon(name: "bulbasaur")
        mockService.pokemonDetailResult = .success(pokemon)
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        
        sut.toggleFavorite()
        
        XCTAssertTrue(mockRepository.pokemonAddedCalled)
        XCTAssertEqual(mockRepository.pokemonAdded, "bulbasaur")
        XCTAssertFalse(mockRepository.pokemonRemovedCalled)
    }
    
    func test_toggleFavorite_whenCurrentDetailIsNil_shouldDoNothing() {
        sut.toggleFavorite()
        
        XCTAssertFalse(mockRepository.pokemonAddedCalled)
        XCTAssertFalse(mockRepository.pokemonRemovedCalled)
        XCTAssertNil(mockRepository.pokemonAdded)
        XCTAssertNil(mockRepository.pokemonRemoved)
    }
    
    func test_fetchPokemonDetail_whenPokemonIsFavorited_shouldPassFavoritedStatusToDelegate() {
        let pokemon = createSamplePokemon()
        mockService.pokemonDetailResult = .success(pokemon)
        
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        XCTAssertFalse(mockDelegate.loadedIsFavorited)
        
        mockRepository.containsToBeReturned = true
        
        sut.fetchPokemonDetail()
        
        XCTAssertTrue(mockDelegate.loadedIsFavorited)
    }
    
    func test_fetchPokemonDetail_whenLoadingDifferentPokemons_shouldHandleFavoritesCorrectly() {
        let bulbasaur = createSamplePokemon(id: 1, name: "Bulbasaur")
        let pikachu = createSamplePokemon(id: 25, name: "Pikachu")
        
        mockService.pokemonDetailResult = .success(bulbasaur)
        mockRepository.containsToBeReturned = false
        sut.fetchPokemonDetail()
        
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Bulbasaur")
        XCTAssertFalse(mockDelegate.loadedIsFavorited)
        
        mockService.pokemonDetailResult = .success(pikachu)
        mockRepository.containsToBeReturned = false
        
        sut.fetchPokemonDetail()
        
        XCTAssertEqual(mockDelegate.loadedDetail?.name, "Pikachu")
        XCTAssertEqual(mockDelegate.loadedDetail?.id, 25)
        XCTAssertFalse(mockDelegate.loadedIsFavorited)
    }
    
    func createSamplePokemon(id: Int = 1, name: String = "Bulbasaur") -> PokemonDetail {
        
        return PokemonDetail(
            id: id,
            name: name,
            height: 7.0,
            weight: 69.0,
            types: [.grass],
            imageUrl: "https://example.com/bulbassaur.png"
        )
    }
}
