//
//  PokemonCellView.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import UIKit

class PokemonCellView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, numberLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func setupLayout() {
        self.addSubview(containerView)
        containerView.addSubview(pokemonImageView)
        containerView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            pokemonImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            pokemonImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            pokemonImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 90),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 90),
            
            infoStackView.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        numberLabel.text = String(format: "#%03d", pokemon.number)
        
        if let imageUrl = URL(string: pokemon.pokemonImage) {
            pokemonImageView.loadImage(urlString: pokemon.pokemonImage)
        }
    }
    
    func prepareForReuse() {
        pokemonImageView.image = nil
        nameLabel.text = nil
        numberLabel.text = nil
    }
    
    private func loadImage(from url: URL) {
        
        if let image = imageCache[url.absoluteString] {
            pokemonImageView.image = image
            print("pegou de cache")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                imageCache[url.absoluteString] = image
                print("Pegou da api")
                self?.pokemonImageView.image = image
            }
        }
    }
    
}

var imageCache: [String: UIImage] = [:]
