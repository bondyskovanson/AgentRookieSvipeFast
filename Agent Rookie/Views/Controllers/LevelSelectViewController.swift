import UIKit

final class LevelSelectViewController: UIViewController {
    private var backgroundGradient: CAGradientLayer?
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var stats = CareerStats()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradient = Theme.applyBackground(to: view)
        setupNavBar()
        setupScroll()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationController.shared.lockToPortrait()
        stats = DataManager.shared.loadCareerStats()
        rebuildLevels()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient?.frame = view.bounds
    }

    private func setupNavBar() {
        let backButton = Theme.backButton(target: self, action: #selector(backTapped))
        view.addSubview(backButton)

        let titleLabel = UILabel()
        titleLabel.text = "SELECT LEAGUE"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 96),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 4),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func rebuildLevels() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for level in LevelCatalog.levels {
            contentStack.addArrangedSubview(makeLevelCard(level))
        }
    }

    private func makeLevelCard(_ level: GameLevel) -> UIView {
        let unlocked = stats.isUnlocked(level.index)
        let completed = stats.isCompleted(level.index)
        let best = stats.levelBestScores[level.index] ?? 0

        let card = UIControl()
        card.backgroundColor = Palette.card
        card.layer.cornerRadius = 20
        card.layer.cornerCurve = .continuous
        card.tag = level.index
        card.translatesAutoresizingMaskIntoConstraints = false
        if unlocked {
            card.addTarget(self, action: #selector(levelTapped(_:)), for: .touchUpInside)
            card.layer.borderWidth = 1.5
            card.layer.borderColor = level.accent.withAlphaComponent(0.4).cgColor
        } else {
            card.alpha = 0.55
        }

        let accentBar = UIView()
        accentBar.backgroundColor = unlocked ? level.accent : UIColor.white.withAlphaComponent(0.25)
        accentBar.layer.cornerRadius = 3
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(accentBar)

        let numberLabel = UILabel()
        numberLabel.text = "\(level.displayNumber)"
        numberLabel.font = UIFont.systemFont(ofSize: 34, weight: .black)
        numberLabel.textColor = unlocked ? level.accent : UIColor.white.withAlphaComponent(0.4)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(numberLabel)

        let nameLabel = UILabel()
        nameLabel.text = level.name
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nameLabel)

        let statusLabel = UILabel()
        if !unlocked {
            statusLabel.text = "🔒 Locked"
        } else if completed {
            statusLabel.text = "✓ Completed"
        } else {
            statusLabel.text = level.tagline
        }
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        statusLabel.textColor = completed
            ? Palette.primary
            : UIColor.white.withAlphaComponent(0.7)
        statusLabel.numberOfLines = 2
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(statusLabel)

        let infoLabel = UILabel()
        infoLabel.text = "🎯 OVR \(level.targetOVR)   ·   💰 $\(level.budget)M   ·   ⏱ \(Int(level.duration))s"
        infoLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        infoLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(infoLabel)

        let bestLabel = UILabel()
        bestLabel.text = best > 0 ? "Best \(best)" : ""
        bestLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        bestLabel.textColor = Palette.gold
        bestLabel.textAlignment = .right
        bestLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(bestLabel)

        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 116),

            accentBar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            accentBar.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            accentBar.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            accentBar.widthAnchor.constraint(equalToConstant: 6),

            numberLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 14),
            numberLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 42),

            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: bestLabel.leadingAnchor, constant: -8),

            bestLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            bestLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),

            infoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            infoLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18)
        ])
        return card
    }

    @objc private func levelTapped(_ sender: UIControl) {
        let level = LevelCatalog.level(at: sender.tag)
        HapticsManager.shared.lightImpact()
        let gameVC = GameViewController(level: level)
        navigationController?.pushViewController(gameVC, animated: true)
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
