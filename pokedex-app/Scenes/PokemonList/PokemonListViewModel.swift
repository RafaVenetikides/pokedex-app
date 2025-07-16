//
//  PokemonListViewModel.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

protocol PokemonListViewModelDelegate: AnyObject {
    func didUpdatePokemonList()
    func didFaildWithError(_ message: String)
}

final class PokemonListViewModel {
    weak var delegate: PokemonListViewModelDelegate?
    private let service: PokemonServiceProtocol
    private(set) var pokemons: [Pokemon] = []
    
    init (service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    func fetchPokemons() {
        service.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
                self?.delegate?.didUpdatePokemonList()
            case .failure(let error):
                self?.delegate?.didFaildWithError(error.localizedDescription)
            }
        }
    }
    
    func getPokemon(at index: Int) -> Pokemon {
        return pokemons[index]
    }
    
    var numberOfPokemons: Int {
        return pokemons.count
    }
}
