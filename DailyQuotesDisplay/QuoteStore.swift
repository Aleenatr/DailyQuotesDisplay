import Foundation

class QuoteStore {

    // Shared instance — one single store used everywhere in the app
    static let shared = QuoteStore()

    // All quotes — built-in + user added
    var quotes: [Quote] = [
        Quote(text: "Be the change you wish to see in the world.", author: "Mahatma Gandhi"),
        Quote(text: "Stay hungry, stay foolish.", author: "Steve Jobs"),
        Quote(text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
        Quote(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
        Quote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon"),
        Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
        Quote(text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky"),
        Quote(text: "Whether you think you can or you think you can't, you're right.", author: "Henry Ford"),
    ]

    func addQuote(_ quote: Quote) {
        quotes.append(quote)
    }

    func deleteQuote(at index: Int) {
        quotes.remove(at: index)
    }
}
