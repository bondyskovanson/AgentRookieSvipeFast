import UIKit

final class HowToPlayViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupContent()
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

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupContent() {
        let titleLabel = UILabel()
        titleLabel.text = "HOW TO PLAY"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        stack.addArrangedSubview(makeRow(
            icon: "⏱️",
            title: "Beat the clock",
            text: "Player cards fly onto the table. Decide fast before the auction timer runs out."
        ))
        stack.addArrangedSubview(makeRow(
            icon: "⬅️",
            title: "Buy rookies",
            text: "Swipe a ROOKIE card LEFT to sign them. It costs money but raises your squad rating."
        ))
        stack.addArrangedSubview(makeRow(
            icon: "➡️",
            title: "Sell veterans",
            text: "Swipe a VETERAN card RIGHT to accept the bid. You gain money but lose that player."
        ))
        stack.addArrangedSubview(makeRow(
            icon: "🎯",
            title: "Hit the target",
            text: "Each league sets a target squad OVR. Reach it before full time to win and unlock the next league."
        ))
        stack.addArrangedSubview(makeRow(
            icon: "🏆",
            title: "Climb the leagues",
            text: "Five leagues, each tougher: higher targets, bigger budgets and less time. Chase the best score."
        ))

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func makeRow(icon: String, title: String, text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        container.layer.cornerRadius = 16

        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 30)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconLabel)
        container.addSubview(titleLabel)
        container.addSubview(textLabel)

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            textLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        return container
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
