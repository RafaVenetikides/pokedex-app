//
//  MockPokemonListDelegate.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 23/07/25.
//

@testable import pokedex_app

final class MockPokemonListDelegate: PokemonListViewModelDelegate {
    var didUpdateCalled = false
    var didFailCalled = false
    var errorMessage: String?
    
    func didUpdatePokemonList() {
        didUpdateCalled = true
    }
    
    func didFaildWithError(_ message: String) {
        didFailCalled = true
        errorMessage = message
    }
}

final class MockPokemonDetailDelegate: PokemonDetailViewModelDelegate {
    
    var didLoadDetailCalled = false
    var didFailCalled = false
    var loadedDetail: PokemonDetail?
    var loadedIsFavorited: Bool = false
    var failedWithError: Error?
    
    func didLoadPokemonDetail(detail: pokedex_app.PokemonDetail, isFavorited: Bool) {
        didLoadDetailCalled = true
        loadedDetail = detail
        loadedIsFavorited = isFavorited
    }
    
    func didFailToLoadDetail(with error: any Error) {
        didFailCalled = true
        failedWithError = error
    }
}
