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
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuote()
        styleCard()
    }
    
    func styleCard() {
        
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = false

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 10

        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
    }
    
    func showCurrentQuote() {
        let quote = quotes[currentIndex]
        
        UIView.animate(withDuration: 0.2, animations: {
            self.quoteLabel.alpha = 0
            self.authorLabel.alpha = 0
        }) { _ in
            self.quoteLabel.text = quote.text
            self.authorLabel.text = "— \(quote.author)"

            UIView.animate(withDuration: 0.4) {
                self.quoteLabel.alpha = 1
                self.authorLabel.alpha = 1
            }
        }
    }

    @IBAction func nextQuoteTapped(_ sender: Any) {
        currentIndex += 1
        if currentIndex >= quotes.count {
            currentIndex = 0
        }
        showCurrentQuote()
    }
    
}

