//
//  PokemonDetailView.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 16/07/25.
//

import UIKit

protocol PokemonDetailViewDelegate: AnyObject{
    func didTapFavorite()
    func didTapImage()
}

class PokemonDetailView: UIView {
    weak var delegate: PokemonDetailViewDelegate?
    
    private var isFavorited = false {
        didSet {
            let imageName = isFavorited ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc private func favoriteTapped() {
        isFavorited.toggle()
        delegate?.didTapFavorite()
    }
    
    @objc private func imageTapped() {
        delegate?.didTapImage()
    }
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cardView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.4
        iv.layer.shadowOffset = CGSize(width: 2, height: 6)
        iv.layer.shadowRadius = 3
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.font = UIFont(name: "PKMN-RBYGSC", size: 32)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PKMN-RBYGSC", size: 18)
        label.text = "Types:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//    private let typeLabel: UILabel = {
//        let label = UILabel()
////        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        label.font = UIFont(name: "PKMN-RBYGSC", size: 14)
//        label.textAlignment = .center
//        label.textColor = .white
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        return label
//    }()
    
    private let typeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let heightTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PKMN-RBYGSC", size: 16)
        label.text = "Height:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont(name: "PKMN-RBYGSC", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var heightStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [heightTitle, heightLabel])
        stack.axis = .horizontal
        stack.spacing = 90
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private var weightTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PKMN-RBYGSC", size: 16)
        label.text = "Weight:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont(name: "PKMN-RBYGSC", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightTitle, weightLabel])
        stack.axis = .horizontal
        stack.spacing = 90
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightStack, weightStack])
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                typeTitle,
                typeStackView,
                infoStackView,
            ]
        )
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
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
        addSubview(imageView)
        cardView.addSubview(mainStackView)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            favoriteButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            cardView.widthAnchor.constraint(equalTo: widthAnchor),
            cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -30),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            typeStackView.heightAnchor.constraint(equalToConstant: 30),
            typeStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
        ])
    }
    
    func configure(with pokemonDetail: PokemonDetail, isFavorited: Bool) {
        nameLabel.text = pokemonDetail.name.capitalized
        imageView.image = UIImage(named: pokemonDetail.imageUrl)
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        heightLabel.text = "\(pokemonDetail.height)m"
        weightLabel.text = "\(pokemonDetail.weight)kg"
        
        for type in pokemonDetail.types {
            let typeLabel = createTypeLabel(for: type)
            typeStackView.addArrangedSubview(typeLabel)
        }
        
        if let primaryType = pokemonDetail.types.first {
//            typeLabel.backgroundColor = primaryType.getColor()
            backgroundColor = primaryType.getColor()
        }
        
        imageView.loadImage(urlString: pokemonDetail.imageUrl)
        
        configureButton(isFavorited: isFavorited)
        
        if let imageUrl = URL(string: pokemonDetail.imageUrl) {
            loadImage(from: imageUrl)
        }
    }
    
    private func createTypeLabel(for type: PokemonType) -> UILabel {
        let label = PaddingLabel()
        label.text = type.getTitle()
        label.backgroundColor = type.getColor()
        label.textColor = .white
        label.font = UIFont(name: "PKMN-RBYGSC", size: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
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

class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 8, left: 30, bottom: 8, right: 30)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
    }
}
