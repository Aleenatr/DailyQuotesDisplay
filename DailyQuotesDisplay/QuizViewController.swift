import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var quotes: [Quote] = []
    
    var currentIndex = 0
    var isShowingQuote = true
    
    override func viewDidLoad() {
        quotes = QuoteStore.shared.quotes
        
        super.viewDidLoad()
        styleCard()
        showCurrentQuote()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        cardView.addGestureRecognizer(tap)
        cardView.isUserInteractionEnabled = true
    }
    
    func styleCard() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 10
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
    }
    
    func showCurrentQuote() {
        let quote = quotes[currentIndex]
        quoteLabel.text = quote.text
        authorLabel.text = "— \(quote.author)"
        authorLabel.isHidden = true
        isShowingQuote = true
        cardView.backgroundColor = UIColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1)
    }
    
    @objc func flipCard() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(with: cardView, duration: 0.6, options: transitionOptions, animations: {
            if self.isShowingQuote {
                self.quoteLabel.isHidden = true
                self.authorLabel.isHidden = false
                self.cardView.backgroundColor = UIColor(red: 0.2, green: 0.45, blue: 0.3, alpha: 1)
            } else {
                self.quoteLabel.isHidden = false
                self.authorLabel.isHidden = true
                self.cardView.backgroundColor = UIColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1)
                }
        }, completion: nil)
        
        isShowingQuote = !isShowingQuote
    }
    
    @IBAction func nextQuoteTapped(_ sender: UIButton) {
        currentIndex += 1
        if currentIndex >= quotes.count { currentIndex = 0 }
        showCurrentQuote()
    }
}
