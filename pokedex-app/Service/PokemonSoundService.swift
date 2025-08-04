//
//  PokemonSoundService.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 04/08/25.
//

import Foundation
import AVFoundation

protocol PokemonSoundServiceProtocol {
    func playSound(for pokemonName: String)
}

final class PokemonSoundService: PokemonSoundServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private var soundPlayer: AVAudioPlayer?
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func playSound(for pokemonName: String) {
        let formattedName = pokemonName.lowercased()
        let urlString = "https://play.pokemonshowdown.com/audio/cries/\(formattedName).mp3"
        
        
        networkClient.fetchData(from: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        self?.soundPlayer = try AVAudioPlayer(data: data)
                        self?.soundPlayer?.prepareToPlay()
                        self?.soundPlayer?.play()
                    } catch {
                        print("Error creating AVPlayer: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}
