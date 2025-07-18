//
//  FavoritePokemonKeychainRepository.swift
//  pokedex-app
//
//  Created by Rafael Venetikides on 18/07/25.
//

import Foundation
import Security

final class FavoritePokemonKeychainRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonKeychainRepository()
    
    private let service = "com.yourapp.favoritePokemon"
    private let account = "favorites"
    
    private init() {}
    
    func add (_ name: String) {
        var favorites = getFavorites()
        favorites.insert(name.lowercased())
        saveFavorites(favorites)
    }
    
    func remove(_ name: String) {
        var favorites = getFavorites()
        favorites.remove(name.lowercased())
        saveFavorites(favorites)
    }
    
    func contains(_ name: String) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(name.lowercased())
    }
    
    func allFavorites() -> [String] {
        return Array(getFavorites())
    }
    
    private func getFavorites() -> Set<String> {
        guard let data = readFromKeychain() else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([String].self, from: data)
            return Set(favorites)
        } catch {
            print("Error decoding favorites from keychain: \(error)")
            return []
        }
    }
    
    private func saveFavorites(_ favorites: Set<String>) {
        
    }
    
    private func saveToKeychain(_ data: Data) {
        deleteFromKeychain()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess && status != errSecDuplicateItem {
            print("Error saving to Keychain: \(status)")
        }
    }
    
    private func readFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            if status != errSecItemNotFound {
                print("Error reading from Keychain: \(status)")
            }
            
            return nil
        }
    }
    
    private func deleteFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting from Keychain: \(status)")
        }
    }
}
