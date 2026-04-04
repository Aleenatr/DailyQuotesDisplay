import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var allQuotes: [Quote] = []
    var quizQuotes: [Quote] = []    // only 3 random quotes used per game
    var currentIndex = 0
    var score = 0
    var isShowingQuote = true
    var hasAnswered = false
    var answerButtons: [UIButton] = []
    var defaultButtonColor: UIColor?
    var injectedQuotes: [Quote]? = nil   // questions passed from selection screen
    var categoryIndex: Int = 0
    var answeredQuestions: [Int: Bool] = [:]  // key = question index, value = whether already scored
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allQuotes = QuoteStore.shared.quotes
        answerButtons = [answerButton1, answerButton2]
        defaultButtonColor = answerButton1.configuration?.background.backgroundColor

        styleCard()
        styleAnswerButtons()
        setupQuiz()
    }
    
    func setupQuiz() {
        // Use injected quotes if provided, otherwise pick 3 random from all
        answeredQuestions = [:]
        if let injected = injectedQuotes {
            quizQuotes = injected
        } else {
            quizQuotes = Array(allQuotes.shuffled().prefix(3))
        }
        currentIndex = 0
        score = 0
        scoreLabel.text = "Score: 0"
        loadQuestion()
    }
    
    func loadQuestion() {
        guard currentIndex < quizQuotes.count else {
                showResult()
            return
        }

        hasAnswered = false
        isShowingQuote = true

        let current = quizQuotes[currentIndex]

            // Reset card to show quote side
        quoteLabel.text = current.text
        authorLabel.text = current.author
        quoteLabel.isHidden = false
        authorLabel.isHidden = true
        cardView.backgroundColor = UIColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1)

            // Update top labels
        questionLabel.text = "Question \(currentIndex + 1) of \(quizQuotes.count)"
        scoreLabel.text = "Score: \(score)"

        // Use the options stored in the question itself
        var options = [current.optionA, current.optionB].shuffled()

        // Fallback if options are empty (old data)
        let correctAuthor = current.author
        if current.optionA.isEmpty || current.optionB.isEmpty {
            options = [correctAuthor, "Unknown"]
        }

            // Set button titles and reset their colours
        for (i, btn) in answerButtons.enumerated() {
            btn.setTitle(options[i], for: .normal)
            btn.configuration?.background.backgroundColor = defaultButtonColor ?? UIColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1)
            btn.isEnabled = true
        }
        
        prevButton.isHidden = currentIndex == 0
    }
    
    func styleCard() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardView.layer.shadowRadius = 10
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
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
    
    @IBAction func answerTapped(_ sender: UIButton) {
        guard !hasAnswered else { return }  // ignore if already answered
        hasAnswered = true

        let correctAuthor = quizQuotes[currentIndex].author
        let userAnswer = sender.title(for: .normal)

                // Disable both buttons
        answerButtons.forEach { $0.isEnabled = false }

                // Flip card to reveal answer
        flipCard()

                // After flip completes, colour the buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            for btn in self.answerButtons {
                if btn.title(for: .normal) == correctAuthor {
                    btn.configuration?.background.backgroundColor = UIColor(red: 0.15, green: 0.55, blue: 0.3, alpha: 1)//green
                } else {
                    btn.configuration?.background.backgroundColor = UIColor(red: 0.7, green: 0.15, blue: 0.15, alpha: 1)// red
                }
            }

            // Only update score if this question hasn't been answered before
            if self.answeredQuestions[self.currentIndex] == nil {
                self.answeredQuestions[self.currentIndex] = true
                if userAnswer == correctAuthor {
                    self.score += 1
                    self.scoreLabel.text = "Score: \(self.score)"
                }
            }
        }
    }
    
    func styleAnswerButtons() {
        for btn in answerButtons {
            btn.layer.cornerRadius = 10
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
    }
    
    func showResult() {
        let alert = UIAlertController(
            title: "Quiz Complete! 🎉",
            message: "You scored \(score) out of \(quizQuotes.count)!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.setupQuiz()
        })
        alert.addAction(UIAlertAction(title: "Go Home", style: .cancel) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    @IBAction func nextQuoteTapped(_ sender: UIButton) {
        guard hasAnswered else {
                    // User hasn't answered yet
            let alert = UIAlertController(title: "Answer first!", message: "Please pick an answer before moving on.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        currentIndex += 1
        loadQuestion()
    }
    
    @IBAction func prevTapped(_ sender: UIButton) {
        guard currentIndex > 0 else { return }  // can't go before question 1
        currentIndex -= 1
        loadQuestion()

    }
}
