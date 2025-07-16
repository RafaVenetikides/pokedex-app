//
//  PokemonListViewController.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private lazy var viewModel = PokemonListViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view = tableView
        
        viewModel.fetchPokemons()
    }
}

extension PokemonListViewController: PokemonListViewModelDelegate {
    func didUpdatePokemonList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFaildWithError(_ message: String) {
        // TODO: Uncomment after detail view creation
//        self.showAlert(message: "Erro ao carregar a lista \(message)")
        print(message)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.getPokemon(at: indexPath.row)
        cell.configure(with: pokemon)
        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.getPokemon(at: indexPath.row)
        // TODO: Add selection navigation
    }
}
