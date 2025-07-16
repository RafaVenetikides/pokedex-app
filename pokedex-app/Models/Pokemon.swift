//
//  Pokemon.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation
struct Pokemon {
    let name: String
    let number: Int
    let pokemonImage: String
    let pokemonUrl: URL?
}

extension Pokemon {
    static func mock() -> Pokemon {
        return Pokemon(name: "Koffing", number: 109, pokemonImage: "koffing", pokemonUrl: nil)
    }
}
