import UIKit

final class StatisticsViewController: UIViewController {
    private var backgroundGradient: CAGradientLayer?
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradient = Theme.applyBackground(to: view)
        setupNavBar()
        setupScroll()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationController.shared.lockToPortrait()
        rebuild()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient?.frame = view.bounds
    }

    private func setupNavBar() {
        let backButton = Theme.backButton(target: self, action: #selector(backTapped))
        view.addSubview(backButton)

        let titleLabel = UILabel()
        titleLabel.text = "CAREER STATS"
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

    private func rebuild() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let stats = DataManager.shared.loadCareerStats()

        contentStack.addArrangedSubview(makeHeroCard(stats))
        contentStack.addArrangedSubview(makeGrid(stats))
        contentStack.addArrangedSubview(makeProgressCard(stats))

        let resetButton = Theme.flatButton(title: "Reset Statistics", height: 50, fontSize: 16)
        resetButton.setTitleColor(Palette.danger, for: .normal)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        contentStack.addArrangedSubview(resetButton)
    }

    private func makeHeroCard(_ stats: CareerStats) -> UIView {
        let card = UIView()
        card.backgroundColor = Palette.card
        card.layer.cornerRadius = 20
        card.layer.cornerCurve = .continuous

        let caption = UILabel()
        caption.text = "BEST SCORE"
        caption.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        caption.textColor = UIColor.white.withAlphaComponent(0.6)
        caption.textAlignment = .center
        caption.translatesAutoresizingMaskIntoConstraints = false

        let value = UILabel()
        value.text = "\(stats.bestScore)"
        value.font = UIFont.systemFont(ofSize: 64, weight: .black)
        value.textColor = Palette.gold
        value.textAlignment = .center
        value.translatesAutoresizingMaskIntoConstraints = false

        let sub = UILabel()
        sub.text = "Top squad rating reached: OVR \(stats.bestSquadOVR)"
        sub.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        sub.textColor = UIColor.white.withAlphaComponent(0.7)
        sub.textAlignment = .center
        sub.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(caption)
        card.addSubview(value)
        card.addSubview(sub)

        NSLayoutConstraint.activate([
            caption.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            caption.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            value.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 2),
            value.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            sub.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 2),
            sub.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            sub.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            sub.leadingAnchor.constraint(greaterThanOrEqualTo: card.leadingAnchor, constant: 12),
            sub.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -12)
        ])
        return card
    }

    private func makeGrid(_ stats: CareerStats) -> UIView {
        let items: [(String, String)] = [
            ("Games played", "\(stats.gamesPlayed)"),
            ("Players signed", "\(stats.totalSignings)"),
            ("Players sold", "\(stats.totalSales)"),
            ("Total spent", "$\(stats.totalSpent)M"),
            ("Total earned", "$\(stats.totalEarned)M"),
            ("Best OVR", "\(stats.bestSquadOVR)")
        ]

        let column1 = UIStackView()
        column1.axis = .vertical
        column1.spacing = 12
        column1.distribution = .fillEqually
        let column2 = UIStackView()
        column2.axis = .vertical
        column2.spacing = 12
        column2.distribution = .fillEqually

        for (i, item) in items.enumerated() {
            let tile = makeTile(title: item.0, value: item.1)
            if i % 2 == 0 { column1.addArrangedSubview(tile) } else { column2.addArrangedSubview(tile) }
        }

        let row = UIStackView(arrangedSubviews: [column1, column2])
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually
        return row
    }

    private func makeTile(title: String, value: String) -> UIView {
        let tile = UIView()
        tile.backgroundColor = Palette.card
        tile.layer.cornerRadius = 16
        tile.layer.cornerCurve = .continuous
        tile.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
        valueLabel.textColor = .white
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.6
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tile.addSubview(valueLabel)
        tile.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            tile.heightAnchor.constraint(equalToConstant: 76),
            valueLabel.topAnchor.constraint(equalTo: tile.topAnchor, constant: 16),
            valueLabel.leadingAnchor.constraint(equalTo: tile.leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -12),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: tile.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: tile.trailingAnchor, constant: -12)
        ])
        return tile
    }

    private func makeProgressCard(_ stats: CareerStats) -> UIView {
        let card = UIView()
        card.backgroundColor = Palette.card
        card.layer.cornerRadius = 20
        card.layer.cornerCurve = .continuous

        let title = UILabel()
        title.text = "LEAGUE PROGRESS"
        title.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        title.textColor = UIColor.white.withAlphaComponent(0.6)
        title.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(title)

        let completed = max(0, stats.highestLevelCompleted + 1)
        let progressLabel = UILabel()
        progressLabel.text = "\(completed) / \(LevelCatalog.count) leagues conquered"
        progressLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        progressLabel.textColor = .white
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(progressLabel)

        let dots = UIStackView()
        dots.axis = .horizontal
        dots.spacing = 8
        dots.distribution = .fillEqually
        dots.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(dots)

        for level in LevelCatalog.levels {
            let dot = UIView()
            dot.backgroundColor = stats.isCompleted(level.index)
                ? level.accent
                : UIColor.white.withAlphaComponent(0.15)
            dot.layer.cornerRadius = 4
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            dots.addArrangedSubview(dot)
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),

            progressLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            progressLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            progressLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),

            dots.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16),
            dots.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            dots.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            dots.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        return card
    }

    @objc private func resetTapped() {
        let alert = UIAlertController(title: "Reset Statistics?", message: "This clears career stats, level progress and high scores.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            DataManager.shared.resetCareer()
            DataManager.shared.resetHighScores()
            self?.rebuild()
        })
        present(alert, animated: true)
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
