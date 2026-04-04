import Foundation

struct Quote: Codable {
    let text: String
    let author: String      // kept for backward compatibility — now stores correct answer
    let optionA: String
    let optionB: String

    // Convenience init for old quotes that only have text and author
    init(text: String, author: String, optionA: String = "", optionB: String = "") {
        self.text = text
        self.author = author
        self.optionA = optionA
        self.optionB = optionB
    }
}
