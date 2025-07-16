//
//  PokemonDetailViewModel.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

import Foundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didLoadPokemonDetail(detail: PokemonDetail)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailViewModel {
    private let service: PokemonServiceProtocol
    private let url: URL?
//    private let repository: FavoritePokemonRepositoryProtocol
    
    weak var delegate: PokemonDetailViewModelDelegate?
    private var currentDetail: PokemonDetail?
    
    init(
        url: URL?,
        service: PokemonServiceProtocol = PokemonService(),
//        repository: FavoritePokemonRepositoryProtocol = FavoritePokemonUserDefaultsRepository.shared
    ) {
        self.url = url
        self.service = service
        // TODO: Add repository
    }
    
    func fetchPokemonDetail() {
        guard let url = url else {
            return
        }
        
        service.fetchPokemonDetail(from: url) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.currentDetail = detail
                self?.delegate?.didLoadPokemonDetail(detail: detail)
            case .failure(let error):
                self?.delegate?.didFailToLoadDetail(with: error)
            }
        }
    }
    
    // TODO: toggleFavorite
}
