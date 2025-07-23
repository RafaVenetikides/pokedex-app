//
//  MockPokemonService.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 23/07/25.
//

import Foundation

@testable import pokedex_app

final class MockPokemonService: PokemonServiceProtocol {
    var result: Result<[Pokemon], Error>?
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], any Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
    
    var pokemonDetailResult: Result<PokemonDetail, Error>?
    
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetail, any Error>) -> Void) {
        if let result = pokemonDetailResult {
            completion(result)
        }
    }
}
