//
//  PokemonService.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    
    // TODO: Add fetch pokemon detail
}

final class PokemonService: PokemonServiceProtocol {
    let networkClient = NetworkClient()
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        networkClient.fetch(from: urlString, decoteTo: PokemonListResponse.self) { result in
            switch result {
            case .success(let response):
                let pokemons = response.results.map{ $0.toDomainModel() }
                completion(.success(pokemons))
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
    
    // TODO: Add pokemon detail
}

enum ServiceError: Error {
    case invalidURL
    case emptyData
}
