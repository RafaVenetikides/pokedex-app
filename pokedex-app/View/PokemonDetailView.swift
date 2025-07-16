//
//  PokemonDetailView.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

import UIKit

protocol PokemonDetailViewDelegate: AnyObject{
    func didTapFavorite()
}

class PokemonDetailView: UIView {
    weak var delegate: PokemonDetailViewDelegate?
    
    var onImageTap: (() -> Void)?
    
    private var isFavorited = false {
        didSet {
            let imageName = isFavorited ? "star.fill" : "star"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc private func favoriteTapped() {
        isFavorited.toggle()
        delegate?.didTapFavorite()
    }
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    private let cardView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowOffset = CGSize(width: 0, height: 2)
        iv.layer.shadowRadius = 4
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightLabel, weightLabel])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                imageView,
                nameLabel,
                typeLabel,
                infoStackView,
                favoriteButton,
            ]
        )
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has nor been implemented")
    }
    
    private func setupLayout() {
        addSubview(cardView)
        cardView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            typeLabel.heightAnchor.constraint(equalToConstant: 30),
            typeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
        ])
    }
    
    func configure(with pokemonDetail: PokemonDetail) {
        nameLabel.text = pokemonDetail.name.capitalized
        imageView.image = UIImage(named: pokemonDetail.imageUrl)
        typeLabel.text = pokemonDetail.types.map { $0.getTitle() }.joined(separator: ", ")
        heightLabel.text = "Height: \(pokemonDetail.height)m"
        weightLabel.text = "Weight: \(pokemonDetail.weight)kg"
        
        if let primaryType = pokemonDetail.types.first {
            typeLabel.backgroundColor = primaryType.getColor()
            backgroundColor = primaryType.getColor()
        }
        
        imageView.loadImage(urlString: pokemonDetail.imageUrl)
        
        configureButton(isFavorited: isFavorited)
        
        if let imageUrl = URL(string: pokemonDetail.imageUrl) {
            loadImage(from: imageUrl)
        }
    }
    
    private func configureButton(isFavorited: Bool) {
        self.isFavorited = isFavorited
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
