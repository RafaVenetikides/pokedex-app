//
//  PokemonService.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    
    func fetchPokemonDetail(from url: URL, completion: @escaping(Result<PokemonDetail, Error>) -> Void)
}

final class PokemonService: PokemonServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        func performRequest() {
            networkClient.fetch(from: urlString, decoteTo: PokemonListResponse.self) { result in
                switch result {
                case .success(let response):
                    let pokemons = response.results.map { $0.toDomainModel() }
                    completion(.success(pokemons))
                case .failure(let error):
                        completion(.failure(error))
                    
                }
            }
        }
        
        performRequest()
    }
    
    func fetchPokemonDetail(from url: URL, completion: @escaping (Result<PokemonDetail, any Error>) -> Void) {
        networkClient.fetch(from: url.absoluteString, decoteTo: PokemonDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomainModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ServiceError: Error {
    case invalidURL
    case emptyData
}
