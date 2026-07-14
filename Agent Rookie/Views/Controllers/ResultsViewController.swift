import UIKit

final class ResultsViewController: UIViewController {
    var onPlayAgain: (() -> Void)?
    var onNextLevel: (() -> Void)?
    var onExit: (() -> Void)?

    private let result: GameResult
    private let isNewRecord: Bool
    private var backgroundGradient: CAGradientLayer?

    init(result: GameResult, isNewRecord: Bool) {
        self.result = result
        self.isNewRecord = isNewRecord
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let level = LevelCatalog.level(at: result.levelIndex)
        backgroundGradient = Theme.applyBackground(to: view, top: level.accentDark)
        setupContent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient?.frame = view.bounds
    }

    private func setupContent() {
        let level = LevelCatalog.level(at: result.levelIndex)
        let hasNextLevel = result.passed && (result.levelIndex + 1) < LevelCatalog.count

        let headerLabel = UILabel()
        headerLabel.text = result.passed ? "LEAGUE WON" : "FULL TIME"
        headerLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)

        let levelLabel = UILabel()
        levelLabel.text = "LV \(level.displayNumber) · \(result.levelName)"
        levelLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        levelLabel.textColor = level.accent
        levelLabel.textAlignment = .center
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)

        let banner = PaddedLabel()
        if isNewRecord {
            banner.text = "★ NEW RECORD"
            banner.backgroundColor = Palette.gold.withAlphaComponent(0.9)
            banner.textColor = UIColor(red: 0.2, green: 0.15, blue: 0.0, alpha: 1.0)
        } else if result.passed {
            banner.text = "TARGET REACHED ✓"
            banner.backgroundColor = Palette.primary.withAlphaComponent(0.9)
            banner.textColor = .white
        } else {
            banner.text = "TARGET MISSED · OVR \(result.squadOVR)/\(result.targetOVR)"
            banner.backgroundColor = Palette.danger.withAlphaComponent(0.85)
            banner.textColor = .white
        }
        banner.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        banner.textAlignment = .center
        banner.layer.cornerRadius = 14
        banner.clipsToBounds = true
        banner.textInsets = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)

        let scoreLabel = UILabel()
        scoreLabel.text = "\(result.score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 72, weight: .black)
        scoreLabel.textColor = UIColor(red: 0.4, green: 0.9, blue: 0.55, alpha: 1.0)
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)

        let scoreCaption = UILabel()
        scoreCaption.text = "SCORE"
        scoreCaption.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        scoreCaption.textColor = UIColor.white.withAlphaComponent(0.6)
        scoreCaption.textAlignment = .center
        scoreCaption.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreCaption)

        let statsCard = UIView()
        statsCard.backgroundColor = Palette.card
        statsCard.layer.cornerRadius = 18
        statsCard.layer.cornerCurve = .continuous
        statsCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsCard)

        let statsStack = UIStackView()
        statsStack.axis = .vertical
        statsStack.spacing = 13
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsCard.addSubview(statsStack)

        statsStack.addArrangedSubview(makeStatRow(title: "Squad rating (OVR)", value: "\(result.squadOVR) / \(result.targetOVR)"))
        statsStack.addArrangedSubview(makeStatRow(title: "Squad size", value: "\(result.squadSize) players"))
        statsStack.addArrangedSubview(makeStatRow(title: "Budget left", value: "$\(result.budgetLeft)M"))
        statsStack.addArrangedSubview(makeStatRow(title: "Signings / Sales", value: "\(result.signings) / \(result.sales)"))
        statsStack.addArrangedSubview(makeStatRow(title: "Spent / Earned", value: "$\(result.spent)M / $\(result.earned)M"))

        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        if hasNextLevel {
            let nextLevel = LevelCatalog.level(at: result.levelIndex + 1)
            let nextButton = Theme.gradientButton(title: "NEXT LEAGUE ›", colors: [nextLevel.accent, nextLevel.accentDark], height: 60, fontSize: 21)
            nextButton.addTarget(self, action: #selector(nextLevelTapped), for: .touchUpInside)
            buttonStack.addArrangedSubview(nextButton)

            let retry = Theme.flatButton(title: "Replay League", height: 50, fontSize: 17)
            retry.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)
            buttonStack.addArrangedSubview(retry)
        } else {
            let playAgain = Theme.gradientButton(title: result.passed ? "PLAY AGAIN" : "TRY AGAIN", colors: [Palette.primary, Palette.primaryDark], height: 60, fontSize: 22)
            playAgain.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)
            buttonStack.addArrangedSubview(playAgain)
        }

        let exit = Theme.flatButton(title: "Main Menu", height: 50, fontSize: 17)
        exit.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        buttonStack.addArrangedSubview(exit)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            levelLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            banner.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 14),
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scoreLabel.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 14),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scoreCaption.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: -6),
            scoreCaption.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            statsCard.topAnchor.constraint(equalTo: scoreCaption.bottomAnchor, constant: 24),
            statsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            statsCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            statsStack.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 20),
            statsStack.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -20),
            statsStack.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 20),
            statsStack.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -20),

            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func makeStatRow(title: String, value: String) -> UIView {
        let row = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(titleLabel)
        row.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            row.heightAnchor.constraint(equalToConstant: 22)
        ])
        return row
    }

    @objc private func playAgainTapped() {
        onPlayAgain?()
    }

    @objc private func nextLevelTapped() {
        onNextLevel?()
    }

    @objc private func exitTapped() {
        onExit?()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
