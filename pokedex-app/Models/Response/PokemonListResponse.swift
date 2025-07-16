//
//  PokemonListResponse.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let name: String
    let pokemonUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case pokemonUrl = "url"
    }
    
    func toDomainModel() -> Pokemon {
        let pokemonNumber = pokemonUrl.extractPokemonNumber() ?? 0
        let pokemonImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonNumber).png"
        
        let url: URL? = URL(string: pokemonUrl)
        
        return Pokemon(
            name: name.capitalized,
            number: pokemonNumber.description.extractPokemonNumber() ?? 0,
            pokemonImage: pokemonImage,
            pokemonUrl: url!
        )
    }
}

extension String {
    func extractPokemonNumber() -> Int? {
        let components = self.split(separator: "/")
        if let lasComponent = components.last, lasComponent.isEmpty, components.count > 1 {
            return Int(components[components.count - 2])
        } else if let lastComponent = components.last {
            return Int(lastComponent)
        }
        return nil
    }
}
