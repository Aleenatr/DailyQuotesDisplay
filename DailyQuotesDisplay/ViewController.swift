//
//  ViewController.swift
//  DailyQuotesDisplay
//
//  Created by Aleena TR on 02/04/26.
//

import UIKit

class ViewController: UIViewController {
    
    let quotes: [Quote] = [
            Quote(text: "Be the change you wish to see in the world.", author: "Mahatma Gandhi"),
            Quote(text: "Stay hungry, stay foolish.", author: "Steve Jobs"),
            Quote(text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
            Quote(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
            Quote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon"),
            Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
            Quote(text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky"),
            Quote(text: "Whether you think you can or you think you can't, you're right.", author: "Henry Ford"),
    ]

    var currentIndex = 0

    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuote()
    }
    
    func showCurrentQuote() {
        let quote = quotes[currentIndex]
        quoteLabel.text = quote.text
        authorLabel.text = "— \(quote.author)"
    }

    @IBAction func nextQuoteTapped(_ sender: Any) {
        currentIndex += 1
        if currentIndex >= quotes.count {
            currentIndex = 0
        }
        showCurrentQuote()
    }
    
}

