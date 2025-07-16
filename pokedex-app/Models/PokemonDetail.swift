//
//  PokemonDetail.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

struct PokemonDetail {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [PokemonType]
    let imageUrl: String
}

extension PokemonDetail {
    static func mock() -> PokemonDetail {
        .init(
            id: 54,
            name: "Psyduck",
            height: 0.8,
            weight: 19.6,
            types: [.water],
            imageUrl: "psyduck"
        )
    }
}
