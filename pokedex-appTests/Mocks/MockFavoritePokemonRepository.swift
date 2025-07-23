//
//  MockFavoritePokemonRepository.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 23/07/25.
//

@testable import pokedex_app

final class MockFavoritePokemonRepository: FavoritePokemonRepositoryProtocol {
    
    var pokemonAddedCalled: Bool = false
    var pokemonAdded: String?
    func add(_ name: String) {
        pokemonAdded = name
        pokemonAddedCalled = true
    }
    
    var pokemonRemovedCalled: Bool = false
    var pokemonRemoved: String?
    func remove(_ name: String) {
        pokemonRemoved = name
        pokemonRemovedCalled = true
    }
    
    var containsToBeReturned: Bool = false
    var containsCalled: Bool = false
    func contains(_ name: String) -> Bool {
        containsCalled = true
        return containsToBeReturned
    }
    
    func allFavorites() -> [String] {
        []
    }
    
    func reset() {
        
    }
}
