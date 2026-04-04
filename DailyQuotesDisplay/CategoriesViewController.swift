import UIKit

class CategoriesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = DataStore.shared.categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.quotes.count) questions"
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - Tap Category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showQuestions", sender: indexPath.row)
    }

    // MARK: - Pass data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestions",
           let vc = segue.destination as? QuestionsListViewController,
           let index = sender as? Int {
            vc.categoryIndex = index
        }
    }

    // MARK: - Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataStore.shared.deleteCategory(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Add Category
    @IBAction func addCategoryTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Category", message: "Enter a name", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "e.g. History" }
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                DataStore.shared.addCategory(name: name)
                self.tableView.reloadData()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
