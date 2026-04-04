import Foundation

class DataStore {

    // Single shared instance used everywhere in the app
    static let shared = DataStore()

    private let key = "saved_categories"  // key used to save in UserDefaults

    // All categories stored in memory
    var categories: [Category] = []

    private init() {
        //UserDefaults.standard.removeObject(forKey: key) //just to reset the new data
        load()         // load saved data when app starts
        if categories.isEmpty {
            seedBuiltInData()  // first time only — add built-in categories
        }
    }

    // MARK: - Built-in Starter Data
    func seedBuiltInData() {
        let maths = Category(name: "Maths", quotes: [
            Quote(text: "What is the value of Pi to 2 decimal places?",
                  author: "3.14", optionA: "3.14", optionB: "3.41"),
            Quote(text: "What is the square root of 144?",
                  author: "12", optionA: "12", optionB: "14"),
            Quote(text: "How many sides does a hexagon have?",
                  author: "6", optionA: "6", optionB: "8"),
            Quote(text: "What is 15% of 200?",
                  author: "30", optionA: "30", optionB: "25"),
        ])

        let science = Category(name: "Science", quotes: [
            Quote(text: "What planet is closest to the sun?",
                  author: "Mercury", optionA: "Mercury", optionB: "Venus"),
            Quote(text: "What gas do plants absorb from the air?",
                  author: "Carbon Dioxide", optionA: "Carbon Dioxide", optionB: "Oxygen"),
            Quote(text: "What is the chemical symbol for water?",
                  author: "H2O", optionA: "H2O", optionB: "CO2"),
            Quote(text: "How many bones are in the adult human body?",
                  author: "206", optionA: "206", optionB: "208"),
        ])

        let social = Category(name: "Social Science", quotes: [
            Quote(text: "Who was the first President of the United States?",
                  author: "George Washington", optionA: "George Washington", optionB: "Abraham Lincoln"),
            Quote(text: "In which year did World War II end?",
                  author: "1945", optionA: "1945", optionB: "1939"),
            Quote(text: "What is the capital of Australia?",
                  author: "Canberra", optionA: "Canberra", optionB: "Sydney"),
            Quote(text: "Which is the largest continent?",
                  author: "Asia", optionA: "Asia", optionB: "Africa"),
        ])

        let english = Category(name: "English", quotes: [
            Quote(text: "What is the synonym of 'happy'?",
                  author: "Joyful", optionA: "Joyful", optionB: "Sad"),
            Quote(text: "Who wrote Romeo and Juliet?",
                  author: "William Shakespeare", optionA: "William Shakespeare", optionB: "Charles Dickens"),
            Quote(text: "What is the antonym of 'ancient'?",
                  author: "Modern", optionA: "Modern", optionB: "Old"),
            Quote(text: "What type of word describes a noun?",
                  author: "Adjective", optionA: "Adjective", optionB: "Adverb"),
        ])

        let general = Category(name: "General Knowledge", quotes: [
            Quote(text: "How many colors are in a rainbow?",
                  author: "7", optionA: "7", optionB: "6"),
            Quote(text: "What is the largest ocean on Earth?",
                  author: "Pacific Ocean", optionA: "Pacific Ocean", optionB: "Atlantic Ocean"),
            Quote(text: "How many hours are in a week?",
                  author: "168", optionA: "168", optionB: "144"),
            Quote(text: "What is the national animal of India?",
                  author: "Bengal Tiger", optionA: "Bengal Tiger", optionB: "Lion"),
        ])

        categories = [maths, science, social, english, general]
        save()
    }

    // MARK: - Save to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // MARK: - Load from UserDefaults
    func load() {
        if let saved = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Category].self, from: saved) {
            categories = decoded
        }
    }

    // MARK: - Category Operations
    func addCategory(name: String) {
        let newCategory = Category(name: name)
        categories.append(newCategory)
        save()
    }

    func deleteCategory(at index: Int) {
        categories.remove(at: index)
        save()
    }

    // MARK: - Question Operations
    func addQuestion(_ quote: Quote, toCategoryAt index: Int) {
        categories[index].quotes.append(quote)
        save()
    }

    func deleteQuestion(at questionIndex: Int, fromCategoryAt categoryIndex: Int) {
        categories[categoryIndex].quotes.remove(at: questionIndex)
        save()
    }
}
