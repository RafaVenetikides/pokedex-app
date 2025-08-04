//
//  PokemonDetailViewModel.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

import Foundation
import AVFoundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didLoadPokemonDetail(detail: PokemonDetail, isFavorited: Bool)
    func didFailToLoadDetail(with error: Error)
}

final class PokemonDetailViewModel {
    private let service: PokemonServiceProtocol
    private let url: URL?
    private let repository: FavoritePokemonRepositoryProtocol
    
    weak var delegate: PokemonDetailViewModelDelegate?
    private var currentDetail: PokemonDetail?
    
    private let soundService: PokemonSoundServiceProtocol
    
    init(
        url: URL?,
        service: PokemonServiceProtocol = PokemonService(),
        repository: FavoritePokemonRepositoryProtocol = FavoritePokemonUserDefaultsRepository.shared,
        soundService: PokemonSoundServiceProtocol = PokemonSoundService()
    ) {
        self.url = url
        self.service = service
        self.repository = repository
        self.soundService = soundService
    }
    
    func fetchPokemonDetail() {
        guard let url = url else {
            delegate?.didFailToLoadDetail(with: ServiceError.invalidURL)
            return
        }
        
        service.fetchPokemonDetail(from: url) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.currentDetail = detail
                self?.delegate?.didLoadPokemonDetail(detail: detail,
                                                     isFavorited: self?.isFavorited() ?? false)
            case .failure(let error):
                self?.delegate?.didFailToLoadDetail(with: error)
            }
        }
    }
    
    func toggleFavorite() {
        guard let pokemon = currentDetail else { return }
        
        let name = pokemon.name.lowercased()
        
        if isFavorited() {
            repository.remove(name)
        } else {
            repository.add(name)
        }
    }
    
    func playPokemonSound() {
        guard let pokemon = currentDetail else { return }
        soundService.playSound(for: pokemon.name)
    }
    
    private func isFavorited() -> Bool {
        guard let pokemon = currentDetail else { return false }
        return repository.contains(pokemon.name.lowercased())
    }
}
