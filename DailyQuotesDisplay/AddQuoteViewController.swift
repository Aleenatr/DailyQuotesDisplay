import UIKit

class AddQuoteViewController: UIViewController {

    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var authorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        styleInputs()

    }
    
    func styleInputs() {
        quoteTextView.layer.cornerRadius = 10
        quoteTextView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        quoteTextView.layer.borderWidth = 1
        quoteTextView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        quoteTextView.textColor = .white
        quoteTextView.font = UIFont.systemFont(ofSize: 16)

        authorTextField.layer.cornerRadius = 10
        authorTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        authorTextField.layer.borderWidth = 1
        authorTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        authorTextField.textColor = .white
        authorTextField.attributedPlaceholder = NSAttributedString(string: "Author name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    
    @IBAction func saveQuoteTapped(_ sender: UIButton) {
        guard let quoteText = quoteTextView.text, !quoteText.isEmpty, quoteText != "Enter quote here...",
              let author = authorTextField.text, !author.isEmpty else {
            let alert = UIAlertController(title: "Oops!", message: "Please enter both a quote and an author.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let newQuote = Quote(text: quoteText, author: author)
        QuoteStore.shared.addQuote(newQuote)
        
        let alert = UIAlertController(title: "Saved!", message: "Your quote has been added.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
