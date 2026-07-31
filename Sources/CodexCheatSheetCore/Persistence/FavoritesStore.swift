import Combine
import Foundation

@MainActor
public final class FavoritesStore: ObservableObject {
    private let defaults: UserDefaults
    private let storageKey = "favorites.keys"

    @Published private(set) var keys: [String] = []

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        keys = defaults.stringArray(forKey: storageKey) ?? []
    }

    func contains(_ key: String) -> Bool {
        keys.contains(key)
    }

    func toggle(_ key: String) {
        if let index = keys.firstIndex(of: key) {
            keys.remove(at: index)
        } else {
            keys.append(key)
        }
        persist()
    }

    func add(_ key: String) {
        guard !keys.contains(key) else { return }
        keys.append(key)
        persist()
    }

    func remove(_ key: String) {
        keys.removeAll { $0 == key }
        persist()
    }

    private func persist() {
        defaults.set(keys, forKey: storageKey)
    }
}
