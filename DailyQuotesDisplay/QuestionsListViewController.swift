import UIKit

class QuestionsListViewController: UITableViewController {

    var categoryIndex: Int = 0
    var selectedIndices: Set<Int> = []   // tracks checked questions

    override func viewDidLoad() {
        super.viewDidLoad()
        title = DataStore.shared.categories[categoryIndex].name
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = DataStore.shared.categories[categoryIndex].name
        tableView.reloadData()
    }

    // MARK: - Table Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.categories[categoryIndex].quotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        let quote = DataStore.shared.categories[categoryIndex].quotes[indexPath.row]

        cell.textLabel?.text = quote.text
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "Answer: \(quote.author)"
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1)
        cell.tintColor = UIColor(red: 0.15, green: 0.55, blue: 0.3, alpha: 1)

        // Show checkmark if selected
        cell.accessoryType = selectedIndices.contains(indexPath.row) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    // MARK: - Tap Row to Toggle Checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if selectedIndices.contains(indexPath.row) {
            selectedIndices.remove(indexPath.row)
        } else {
            selectedIndices.insert(indexPath.row)
        }

        tableView.reloadRows(at: [indexPath], with: .none)
    }

    // MARK: - Swipe Left to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // If deleted row was selected, remove it from selection too
            selectedIndices.remove(indexPath.row)

            // Recalculate indices above deleted row
            let updated = selectedIndices.filter { $0 > indexPath.row }.map { $0 - 1 }
            selectedIndices = selectedIndices.filter { $0 < indexPath.row }
            selectedIndices.formUnion(updated)

            DataStore.shared.deleteQuestion(at: indexPath.row, fromCategoryAt: categoryIndex)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Add Question
    @IBAction func addQuestionTapped(_ sender: UIBarButtonItem) {
        // Step 1 — get question and options
        let inputAlert = UIAlertController(
            title: "Add Question",
            message: "Enter the question and two options",
            preferredStyle: .alert)

        inputAlert.addTextField { $0.placeholder = "Question" }
        inputAlert.addTextField { $0.placeholder = "Option A" }
        inputAlert.addTextField { $0.placeholder = "Option B" }

        inputAlert.addAction(UIAlertAction(title: "Next", style: .default) { _ in
            let question = inputAlert.textFields?[0].text ?? ""
            let optA = inputAlert.textFields?[1].text ?? ""
            let optB = inputAlert.textFields?[2].text ?? ""

            guard !question.isEmpty, !optA.isEmpty, !optB.isEmpty else {
                let err = UIAlertController(title: "Fill all fields", message: nil, preferredStyle: .alert)
                err.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(err, animated: true)
                return
            }

            // Step 2 — ask which option is correct
            let correctAlert = UIAlertController(
                title: "Which is correct?",
                message: "Tap the correct answer",
                preferredStyle: .alert)

            correctAlert.addAction(UIAlertAction(title: optA, style: .default) { _ in
                let newQuote = Quote(text: question, author: optA, optionA: optA, optionB: optB)
                DataStore.shared.addQuestion(newQuote, toCategoryAt: self.categoryIndex)
                self.tableView.reloadData()
            })

            correctAlert.addAction(UIAlertAction(title: optB, style: .default) { _ in
                let newQuote = Quote(text: question, author: optB, optionA: optA, optionB: optB)
                DataStore.shared.addQuestion(newQuote, toCategoryAt: self.categoryIndex)
                self.tableView.reloadData()
            })

            correctAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(correctAlert, animated: true)
        })

        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(inputAlert, animated: true)
    }

    // MARK: - Select all the questions
    @IBAction func selectAllTapped(_ sender: UIButton) {
        let total = DataStore.shared.categories[categoryIndex].quotes.count
        if selectedIndices.count == total {
            selectedIndices.removeAll()
        } else {
            selectedIndices = Set(0..<total)
        }
        tableView.reloadData()
    }
    
    // MARK: - Start Quiz
    @IBAction func startQuizTapped(_ sender: UIButton) {
        guard !selectedIndices.isEmpty else {
            let alert = UIAlertController(
                title: "Nothing selected",
                message: "Tap questions to select them first.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let allQuotes = DataStore.shared.categories[categoryIndex].quotes

        // Filter out any indices that no longer exist
        let validIndices = selectedIndices.filter { $0 < allQuotes.count }
        let selected = validIndices.sorted().map { allQuotes[$0] }

        guard !selected.isEmpty else {
            let alert = UIAlertController(
                title: "Nothing selected",
                message: "Tap questions to select them first.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let alert = UIAlertController(
            title: "You selected \(selected.count) question\(selected.count == 1 ? "" : "s")",
            message: "How many do you want to play?",
            preferredStyle: .alert)
        alert.addTextField { field in
            field.keyboardType = .numberPad
            field.text = "\(selected.count)"
        }
        alert.addAction(UIAlertAction(title: "Start", style: .default) { _ in
            let input = alert.textFields?.first?.text ?? ""
            var count = Int(input) ?? selected.count
            if count < 1 { count = 1 }
            if count > selected.count { count = selected.count }
            let finalQuotes = Array(selected.shuffled().prefix(count))
            self.launchQuiz(with: finalQuotes)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Launch Quiz
    func launchQuiz(with quotes: [Quote]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let quizVC = storyboard.instantiateViewController(
            withIdentifier: "QuizViewController") as? QuizViewController else {
            print("ERROR: Make sure Storyboard ID is set to QuizViewController")
            return
        }
        quizVC.injectedQuotes = quotes
        quizVC.categoryIndex = self.categoryIndex
        navigationController?.pushViewController(quizVC, animated: true)
    }
}
