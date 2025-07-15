//
//  PokemonTableViewCell.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    private let customView: PokemonCellView = {
        let view = PokemonCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
