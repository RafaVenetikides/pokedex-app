//
//  FavoritePokemonLocalRepository.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 18/07/25.
//

import Foundation

protocol FavoritePokemonRepositoryProtocol {
    func add(_ name: String)
    func remove(_ name: String)
    func contains(_ name: String) -> Bool
    func allFavorites() -> [String]
}

final class FavoritePokemonLocalRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonLocalRepository()
    
    private var favorites: Set<String> = []
    
    private init() {}
    
    func add(_ name: String) {
        favorites.insert(name)
    }
    
    func remove(_ name: String) {
        favorites.remove(name)
    }
    
    func contains(_ name: String) -> Bool {
        favorites.contains(name.lowercased())
    }
    
    func allFavorites() -> [String] {
        Array(favorites)
    }
}
