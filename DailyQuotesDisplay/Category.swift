import Foundation

struct Category: Codable {
    var id: String              // unique ID for each category
    var name: String
    var quotes: [Quote]

    init(name: String, quotes: [Quote] = []) {
        self.id = UUID().uuidString   // auto generates a unique ID
        self.name = name
        self.quotes = quotes
    }
}
