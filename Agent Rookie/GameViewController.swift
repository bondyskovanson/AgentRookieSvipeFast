import UIKit

final class GameViewController: UIViewController {
    private let level: GameLevel
    private let swipeThreshold: CGFloat = 110

    private var budget = 0
    private var squad: [SquadPlayer] = []
    private var signings = 0
    private var sales = 0
    private var spent = 0
    private var earned = 0
    private var timeRemaining = 0.0
    private var isGameOver = false

    private var timer: Timer?

    private var topCard: CardView?
    private var nextCard: CardView?
    private var topCardData: TransferCard?
    private var nextCardData: TransferCard?

    private let levelBadge = PaddedLabel()
    private let budgetValue = UILabel()
    private let ovrValue = UILabel()
    private let targetValue = UILabel()
    private let timeLabel = UILabel()
    private let timeBarTrack = UIView()
    private let timeBarFill = UIView()
    private var timeBarFillWidth: NSLayoutConstraint?

    private let cardArea = UIView()
    private let buyButton = ThemeGradientButton(type: .custom)
    private let sellButton = ThemeGradientButton(type: .custom)
    private let buyLabel = UILabel()
    private let sellLabel = UILabel()
    private let toastLabel = PaddedLabel()

    private let gradientLayer = CAGradientLayer()
    private let pitchLayer = PitchBackgroundLayer()

    init(level: GameLevel) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupHUD()
        setupCardArea()
        setupControls()
        setupToast()
        startGame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        pitchLayer.frame = view.bounds
    }

    private func setupBackground() {
        view.backgroundColor = Palette.background
        gradientLayer.colors = [
            level.accentDark.cgColor,
            Palette.backgroundBottom.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.layer.insertSublayer(pitchLayer, at: 1)
    }

    private func setupHUD() {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Quit", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        closeButton.layer.cornerRadius = 14
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        closeButton.addTarget(self, action: #selector(quitTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        levelBadge.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        levelBadge.textColor = .white
        levelBadge.textAlignment = .center
        levelBadge.backgroundColor = level.accent.withAlphaComponent(0.9)
        levelBadge.layer.cornerRadius = 13
        levelBadge.clipsToBounds = true
        levelBadge.textInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        levelBadge.text = "LV \(level.displayNumber) · \(level.name.uppercased())"
        levelBadge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelBadge)

        let statsRow = UIStackView()
        statsRow.axis = .horizontal
        statsRow.distribution = .fillEqually
        statsRow.spacing = 10
        statsRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsRow)

        statsRow.addArrangedSubview(makeStatPill(caption: "BUDGET", valueLabel: budgetValue, valueColor: Palette.gold))
        statsRow.addArrangedSubview(makeStatPill(caption: "SQUAD OVR", valueLabel: ovrValue, valueColor: .white))
        statsRow.addArrangedSubview(makeStatPill(caption: "TARGET", valueLabel: targetValue, valueColor: level.accent))

        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)

        timeBarTrack.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        timeBarTrack.layer.cornerRadius = 5
        timeBarTrack.clipsToBounds = true
        timeBarTrack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeBarTrack)

        timeBarFill.backgroundColor = level.accent
        timeBarFill.layer.cornerRadius = 5
        timeBarFill.translatesAutoresizingMaskIntoConstraints = false
        timeBarTrack.addSubview(timeBarFill)

        let fillWidth = timeBarFill.widthAnchor.constraint(equalTo: timeBarTrack.widthAnchor)
        timeBarFillWidth = fillWidth

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            levelBadge.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            levelBadge.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            levelBadge.heightAnchor.constraint(equalToConstant: 26),

            statsRow.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 14),
            statsRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statsRow.heightAnchor.constraint(equalToConstant: 58),

            timeLabel.topAnchor.constraint(equalTo: statsRow.bottomAnchor, constant: 12),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            timeBarTrack.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            timeBarTrack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            timeBarTrack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            timeBarTrack.heightAnchor.constraint(equalToConstant: 10),

            timeBarFill.leadingAnchor.constraint(equalTo: timeBarTrack.leadingAnchor),
            timeBarFill.topAnchor.constraint(equalTo: timeBarTrack.topAnchor),
            timeBarFill.bottomAnchor.constraint(equalTo: timeBarTrack.bottomAnchor),
            fillWidth
        ])
    }

    private func makeStatPill(caption: String, valueLabel: UILabel, valueColor: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = Palette.card
        container.layer.cornerRadius = 14
        container.layer.cornerCurve = .continuous

        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        captionLabel.textColor = UIColor.white.withAlphaComponent(0.55)
        captionLabel.textAlignment = .center
        captionLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        valueLabel.textColor = valueColor
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.7
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(captionLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            captionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            captionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),

            valueLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6)
        ])
        return container
    }

    private func setupCardArea() {
        cardArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardArea)

        		let ratioConstraint = cardArea.heightAnchor.constraint(equalTo: cardArea.widthAnchor, multiplier: 1.42)
ratioConstraint.priority = .defaultHigh

let maxHeight = cardArea.heightAnchor.constraint(lessThanOrEqualToConstant: 650)

        NSLayoutConstraint.activate([
            cardArea.topAnchor.constraint(equalTo: timeBarTrack.bottomAnchor, constant: 22),
            cardArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            cardArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            cardArea.heightAnchor.constraint(equalTo: cardArea.widthAnchor, multiplier: 1.42)

			ratioConstraint,
    maxHeight
            
        ])
    }

    private func setupControls() {
        configureActionButton(buyButton, label: buyLabel, colors: [Palette.primary, Palette.primaryDark])
        configureActionButton(sellButton, label: sellLabel, colors: [Palette.danger, UIColor(red: 0.55, green: 0.14, blue: 0.16, alpha: 1.0)])
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            buyButton.topAnchor.constraint(equalTo: cardArea.bottomAnchor, constant: 22),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            buyButton.widthAnchor.constraint(equalTo: sellButton.widthAnchor),
            buyButton.heightAnchor.constraint(equalToConstant: 66),

            sellButton.topAnchor.constraint(equalTo: buyButton.topAnchor),
            sellButton.leadingAnchor.constraint(equalTo: buyButton.trailingAnchor, constant: 16),
            sellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            sellButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }

    private func configureActionButton(_ button: ThemeGradientButton, label: UILabel, colors: [UIColor]) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.apply(colors: colors)
        button.layer.cornerRadius = 20
        button.layer.cornerCurve = .continuous
        button.clipsToBounds = true
        view.addSubview(button)

        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -8)
        ])
    }

    private func setupToast() {
        toastLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 0
        toastLabel.numberOfLines = 1
        toastLabel.textInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -14),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func startGame() {
        budget = level.budget
        squad = PlayerFactory.startingSquad(for: level)
        signings = 0
        sales = 0
        spent = 0
        earned = 0
        timeRemaining = level.duration
        isGameOver = false

        targetValue.text = "\(level.targetOVR)"
        updateHUD()
        updateTimeBar()

        nextCardData = generateCard()
        topCardData = generateCard()
        nextCard = makeCard(with: nextCardData!, isTop: false)
        topCard = makeCard(with: topCardData!, isTop: true)
        animateCardEntrance(topCard)
        refreshActionButtons()

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    private func animateCardEntrance(_ card: CardView?) {
        guard let card = card else { return }
        card.transform = CGAffineTransform(translationX: 0, y: 40).scaledBy(x: 0.9, y: 0.9)
        card.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: []) {
            card.transform = .identity
            card.alpha = 1
        }
    }

    private func makeCard(with data: TransferCard, isTop: Bool) -> CardView {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.configure(with: data)
        cardArea.addSubview(cardView)
        if !isTop {
            cardArea.sendSubviewToBack(cardView)
        }
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: cardArea.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: cardArea.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: cardArea.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cardArea.trailingAnchor)
        ])

        if isTop {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            cardView.addGestureRecognizer(pan)
        } else {
            cardView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            cardView.alpha = 0.9
        }
        return cardView
    }

    private func generateCard() -> TransferCard {
        if !squad.isEmpty && Double.random(in: 0...1) < level.veteranChance {
            let player = squad.randomElement()!
            return PlayerFactory.veteranCard(from: player)
        }
        return PlayerFactory.rookieCard(for: level)
    }

    @objc private func tick() {
        guard !isGameOver else { return }
        timeRemaining -= 0.1
        if timeRemaining <= 0 {
            timeRemaining = 0
            updateTimeBar()
            endGame()
            return
        }
        updateTimeBar()
    }

    private func updateHUD() {
        budgetValue.text = "$\(budget)M"
        let ovr = currentSquadOVR()
        ovrValue.text = "\(ovr) · \(squad.count)"
        ovrValue.textColor = ovr >= level.targetOVR ? Palette.primary : .white
    }

    private func updateTimeBar() {
        let progress = max(0, min(1, CGFloat(timeRemaining / level.duration)))
        timeBarFillWidth?.isActive = false
        timeBarFillWidth = timeBarFill.widthAnchor.constraint(equalTo: timeBarTrack.widthAnchor, multiplier: max(0.0001, progress))
        timeBarFillWidth?.isActive = true
        timeLabel.text = "AUCTION ENDS IN \(Int(ceil(timeRemaining)))s"
        if timeRemaining <= 10 {
            timeBarFill.backgroundColor = Palette.danger
            timeLabel.textColor = Palette.danger
        }
    }

    private func currentSquadOVR() -> Int {
        guard !squad.isEmpty else { return 0 }
        let total = squad.reduce(0) { $0 + $1.ovr }
        return Int((Double(total) / Double(squad.count)).rounded())
    }

    private func refreshActionButtons() {
        guard let data = topCardData else { return }
        switch data.kind {
        case .rookie:
            buyLabel.text = "BUY\n−$\(data.price)M"
            buyButton.apply(colors: [Palette.primary, Palette.primaryDark])
            sellLabel.text = "PASS"
            sellButton.apply(colors: [UIColor(white: 0.45, alpha: 1.0), UIColor(white: 0.3, alpha: 1.0)])
        case .veteran:
            buyLabel.text = "KEEP"
            buyButton.apply(colors: [UIColor(white: 0.45, alpha: 1.0), UIColor(white: 0.3, alpha: 1.0)])
            sellLabel.text = "SELL\n+$\(data.price)M"
            sellButton.apply(colors: [Palette.danger, UIColor(red: 0.55, green: 0.14, blue: 0.16, alpha: 1.0)])
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let card = topCard, !isGameOver else { return }
        let translation = gesture.translation(in: cardArea)

        switch gesture.state {
        case .changed:
            let rotation = (translation.x / cardArea.bounds.width) * 0.4
            card.transform = CGAffineTransform(translationX: translation.x, y: translation.y * 0.4)
                .rotated(by: rotation)
            card.updateOverlay(forTranslation: translation.x, threshold: swipeThreshold)
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: cardArea)
            if translation.x < -swipeThreshold || velocity.x < -700 {
                commitSwipe(direction: .left)
            } else if translation.x > swipeThreshold || velocity.x > 700 {
                commitSwipe(direction: .right)
            } else {
                snapBack(card)
            }
        default:
            break
        }
    }

    private func snapBack(_ card: CardView) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            card.transform = .identity
        })
        card.resetOverlay()
    }

    @objc private func buyButtonTapped() {
        commitSwipe(direction: .left)
    }

    @objc private func sellButtonTapped() {
        commitSwipe(direction: .right)
    }

    private func commitSwipe(direction: SwipeDirection) {
        guard !isGameOver, let card = topCard, let data = topCardData else { return }

        if !isActionAllowed(data: data, direction: direction) {
            HapticsManager.shared.error()
            showToast("Not enough budget", color: Palette.danger.withAlphaComponent(0.9))
            snapBack(card)
            return
        }

        applyDecision(data: data, direction: direction)
        animateCardAway(card, direction: direction)
        topCard = nil
        topCardData = nil
        promoteNextCard()
    }

    private func isActionAllowed(data: TransferCard, direction: SwipeDirection) -> Bool {
        if data.kind == .rookie && direction == .left {
            return budget >= data.price
        }
        return true
    }

    private func applyDecision(data: TransferCard, direction: SwipeDirection) {
        switch (data.kind, direction) {
        case (.rookie, .left):
            budget -= data.price
            spent += data.price
            squad.append(SquadPlayer(name: data.name, position: data.position, age: data.age, ovr: data.ovr))
            signings += 1
            HapticsManager.shared.success()
            showToast("Signed \(data.name)!", color: UIColor(red: 0.18, green: 0.6, blue: 0.4, alpha: 0.9))
        case (.rookie, .right):
            HapticsManager.shared.lightImpact()
        case (.veteran, .right):
            budget += data.price
            earned += data.price
            if let id = data.squadPlayerID {
                squad.removeAll { $0.id == id }
            }
            sales += 1
            HapticsManager.shared.success()
            showToast("Sold \(data.name)!", color: UIColor(red: 0.8, green: 0.45, blue: 0.2, alpha: 0.9))
        case (.veteran, .left):
            HapticsManager.shared.lightImpact()
        }
        updateHUD()
    }

    private func animateCardAway(_ card: CardView, direction: SwipeDirection) {
        let offX = direction == .left ? -view.bounds.width * 1.2 : view.bounds.width * 1.2
        let rotation: CGFloat = direction == .left ? -0.4 : 0.4
        UIView.animate(withDuration: 0.3, animations: {
            card.transform = CGAffineTransform(translationX: offX, y: 60).rotated(by: rotation)
            card.alpha = 0
        }, completion: { _ in
            card.removeFromSuperview()
        })
    }

    private func promoteNextCard() {
        guard !isGameOver else { return }

        if let promoted = nextCard, let promotedData = nextCardData {
            topCard = promoted
            topCardData = promotedData
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            promoted.addGestureRecognizer(pan)
            UIView.animate(withDuration: 0.2) {
                promoted.transform = .identity
                promoted.alpha = 1.0
            }
        }

        nextCardData = generateCard()
        nextCard = makeCard(with: nextCardData!, isTop: false)
        if let top = topCard {
            cardArea.bringSubviewToFront(top)
        }
        refreshActionButtons()
    }

    private func showToast(_ text: String, color: UIColor) {
        toastLabel.text = text
        toastLabel.backgroundColor = color
        toastLabel.layer.removeAllAnimations()
        toastLabel.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.7, options: [], animations: {
            self.toastLabel.alpha = 0
        })
    }

    private func endGame() {
        guard !isGameOver else { return }
        isGameOver = true
        timer?.invalidate()
        timer = nil

        topCard?.isUserInteractionEnabled = false
        buyButton.isEnabled = false
        sellButton.isEnabled = false

        let squadOVR = currentSquadOVR()
        let passed = squadOVR >= level.targetOVR
        var score = squadOVR * 50 + budget + squad.count * 5
        if passed {
            score += 500 + level.index * 200
        }
        let result = GameResult(
            score: score,
            squadOVR: squadOVR,
            squadSize: squad.count,
            budgetLeft: budget,
            signings: signings,
            sales: sales,
            spent: spent,
            earned: earned,
            levelIndex: level.index,
            levelName: level.name,
            targetOVR: level.targetOVR,
            passed: passed
        )
        let isRecord = DataManager.shared.submitScore(result)

        let resultsVC = ResultsViewController(result: result, isNewRecord: isRecord)
        resultsVC.modalPresentationStyle = .fullScreen
        resultsVC.onPlayAgain = { [weak self] in
            self?.dismiss(animated: true) {
                self?.restartGame()
            }
        }
        resultsVC.onNextLevel = { [weak self] in
            guard let self = self else { return }
            let nextIndex = self.level.index + 1
            self.dismiss(animated: true) {
                if nextIndex < LevelCatalog.count {
                    let nextVC = GameViewController(level: LevelCatalog.level(at: nextIndex))
                    if var controllers = self.navigationController?.viewControllers {
                        controllers.removeLast()
                        controllers.append(nextVC)
                        self.navigationController?.setViewControllers(controllers, animated: true)
                    }
                }
            }
        }
        resultsVC.onExit = { [weak self] in
            self?.dismiss(animated: true) {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        present(resultsVC, animated: true)
    }

    private func restartGame() {
        cardArea.subviews.forEach { $0.removeFromSuperview() }
        topCard = nil
        nextCard = nil
        buyButton.isEnabled = true
        sellButton.isEnabled = true
        timeBarFill.backgroundColor = level.accent
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        startGame()
    }

    @objc private func quitTapped() {
        timer?.invalidate()
        timer = nil
        navigationController?.popViewController(animated: true)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    deinit {
        timer?.invalidate()
    }
}
