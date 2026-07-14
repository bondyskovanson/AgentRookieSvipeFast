import UIKit

final class MenuViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let bestScoreLabel = UILabel()
    private let progressChip = PaddedLabel()
    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationController.shared.lockToPortrait()
        updateBestScore()
        updateProgressChips()
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

    private func setupContent() {
        let crest = UILabel()
        crest.text = "⚽"
        crest.font = UIFont.systemFont(ofSize: 72)
        crest.textAlignment = .center
        crest.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crest)

        titleLabel.text = "AGENT ROOKIE"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        subtitleLabel.text = "Swipe fast. Build the best squad before the clock runs out."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        bestScoreLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        bestScoreLabel.textColor = Palette.gold
        bestScoreLabel.textAlignment = .center
        bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestScoreLabel)

        progressChip.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        progressChip.textColor = .white
        progressChip.textAlignment = .center
        progressChip.backgroundColor = Palette.cardStrong
        progressChip.layer.cornerRadius = 14
        progressChip.clipsToBounds = true
        progressChip.textInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        progressChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressChip)

        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        let playButton = Theme.gradientButton(title: "PLAY", colors: [Palette.primary, Palette.primaryDark], height: 64, fontSize: 24)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(makeButton(title: "Career Stats", primary: false, action: #selector(statsTapped)))
        stack.addArrangedSubview(makeButton(title: "How to Play", primary: false, action: #selector(howToTapped)))
        stack.addArrangedSubview(makeButton(title: "High Scores", primary: false, action: #selector(highScoresTapped)))
        stack.addArrangedSubview(makeButton(title: "Privacy Policy", primary: false, action: #selector(privacyTapped)))

        NSLayoutConstraint.activate([
            crest.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            crest.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

            bestScoreLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            bestScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressChip.topAnchor.constraint(equalTo: bestScoreLabel.bottomAnchor, constant: 12),
            progressChip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressChip.heightAnchor.constraint(equalToConstant: 28),

            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    private func makeButton(title: String, primary: Bool, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: primary ? 24 : 18, weight: primary ? .black : .semibold)
        button.backgroundColor = primary
            ? UIColor(red: 0.18, green: 0.70, blue: 0.42, alpha: 1.0)
            : UIColor.white.withAlphaComponent(0.12)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: primary ? 64 : 52).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func updateBestScore() {
        let best = DataManager.shared.bestScore()
        bestScoreLabel.text = best > 0 ? "Best Score: \(best)" : "No games played yet"
    }

    private func updateProgressChips() {
        let stats = DataManager.shared.loadCareerStats()
        let completed = max(0, stats.highestLevelCompleted + 1)
        progressChip.text = "🏆 \(completed)/\(LevelCatalog.count) leagues   ·   ⚽ \(stats.gamesPlayed) games"
    }

    @objc private func playTapped() {
        navigationController?.pushViewController(LevelSelectViewController(), animated: true)
    }

    @objc private func statsTapped() {
        navigationController?.pushViewController(StatisticsViewController(), animated: true)
    }

    @objc private func howToTapped() {
        navigationController?.pushViewController(HowToPlayViewController(), animated: true)
    }

    @objc private func highScoresTapped() {
        navigationController?.pushViewController(HighScoresViewController(), animated: true)
    }

    @objc private func privacyTapped() {
        let privacyVC = PrivacyPolicyViewController(addressString: AppConstants.privacyPolicyAddress)
        let nav = UINavigationController(rootViewController: privacyVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
