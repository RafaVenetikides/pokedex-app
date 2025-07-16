//
//  NetworkClient.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 15/07/25.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch<T: Decodable> (
        from urlString: String,
        decoteTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

class NetworkClient: NetworkClientProtocol {
    func fetch<T: Decodable>(
        from urlString: String,
        decoteTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("🛑 Erro de rede em NetworkClient: \(error.localizedDescription)")
                    print("📋 Detalhes completos: \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.emptyData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
