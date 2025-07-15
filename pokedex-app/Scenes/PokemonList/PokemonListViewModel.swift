//
//  PokemonListViewModel.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

final class PokemonListViewModel {
    private(set) var pokemons: [String] = []
    
    func getPokemon(at index: Int) -> String {
        return pokemons[index]
    }
    
    var numberOfPokemons: Int {
        return pokemons.count
    }
}
