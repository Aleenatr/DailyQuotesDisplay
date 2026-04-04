import Foundation

// QuoteStore now just points to DataStore
// Kept so existing code does not break
class QuoteStore {
    static let shared = QuoteStore()

    var quotes: [Quote] {
        return DataStore.shared.categories.flatMap { $0.quotes }
    }
}
