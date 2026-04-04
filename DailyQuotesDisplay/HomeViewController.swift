import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        setupUI()
    }

    func setupUI() {
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Guess Who Said This!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle Label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Test your knowledge"
        subtitleLabel.font = UIFont.italicSystemFont(ofSize: 15)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Play Button
        let playButton = UIButton(type: .system)
        playButton.setTitle("▶  Play", for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        playButton.backgroundColor = UIColor(red: 0.15, green: 0.55, blue: 0.3, alpha: 1)
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 14
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        view.addSubview(playButton)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            playButton.widthAnchor.constraint(equalToConstant: 220),
            playButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }

    @objc func playTapped() {
        let vc = CategoriesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
