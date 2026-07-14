import UIKit

final class HighScoresViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var scores: [HighScoreEntry] = []
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        scores = DataManager.shared.loadHighScores()
        setupBackground()
        setupNavBar()
        setupTable()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.04, green: 0.08, blue: 0.07, alpha: 1.0)
        gradientLayer.colors = [
            UIColor(red: 0.08, green: 0.17, blue: 0.13, alpha: 1.0).cgColor,
            UIColor(red: 0.03, green: 0.06, blue: 0.05, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupNavBar() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("‹ Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)

        let titleLabel = UILabel()
        titleLabel.text = "HIGH SCORES"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }

    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scoreCell")
        view.addSubview(tableView)

        emptyLabel.text = "No scores yet.\nPlay a game to set a record!"
        emptyLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = !scores.isEmpty
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension HighScoresViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let entry = scores[indexPath.row]

        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        card.layer.cornerRadius = 14
        card.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(card)

        let rankLabel = UILabel()
        rankLabel.text = "#\(indexPath.row + 1)"
        rankLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        rankLabel.textColor = indexPath.row == 0
            ? UIColor(red: 0.95, green: 0.8, blue: 0.25, alpha: 1.0)
            : UIColor.white.withAlphaComponent(0.7)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false

        let scoreLabel = UILabel()
        scoreLabel.text = "\(entry.score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        scoreLabel.textColor = .white
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        let detailLabel = UILabel()
        if let levelIndex = entry.levelIndex {
            let levelName = LevelCatalog.level(at: levelIndex).name
            detailLabel.text = "\(levelName) · OVR \(entry.squadOVR)"
        } else {
            detailLabel.text = "OVR \(entry.squadOVR) · \(entry.squadSize) players"
        }
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        detailLabel.textAlignment = .right
        detailLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(rankLabel)
        card.addSubview(scoreLabel)
        card.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
            card.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4),
            card.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),

            rankLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 44),

            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            scoreLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),

            detailLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            detailLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return cell
    }
}
