//
//  PokemonDetialViewController.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

import UIKit
import AVFoundation

class PokemonDetailViewController: UIViewController, PokemonDetailViewModelDelegate {
    
    private let pokemonDetailView = PokemonDetailView()
    private let viewModel: PokemonDetailViewModel
    
    init(url: URL?) {
        self.viewModel = PokemonDetailViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.pokemonDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = pokemonDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPokemonDetail()
    }
    
    func didLoadPokemonDetail(detail: PokemonDetail) {
        DispatchQueue.main.async {
            self.pokemonDetailView.configure(with: detail)
        }
    }
    
    func didFailToLoadDetail(with error: any Error) {
        DispatchQueue.main.async {
            self.showAlert(message: "Erro ao carregar detalhe do Pokemon: \(error.localizedDescription)")
        }
    }
}

extension PokemonDetailViewController: PokemonDetailViewDelegate {
    func didTapFavorite() {
        // TODO: Add toggle
//        viewModel.toggleFavorite()
    }
}

extension UIViewController {
    func showAlert(title: String = "Erro", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        DispatchQueue.main.async{
            self.present(alert, animated: true)
        }
    }
}
