import UIKit

enum Palette {
    static let background = UIColor(red: 0.04, green: 0.08, blue: 0.07, alpha: 1.0)
    static let backgroundTop = UIColor(red: 0.08, green: 0.17, blue: 0.13, alpha: 1.0)
    static let backgroundBottom = UIColor(red: 0.03, green: 0.06, blue: 0.05, alpha: 1.0)
    static let primary = UIColor(red: 0.18, green: 0.70, blue: 0.42, alpha: 1.0)
    static let primaryDark = UIColor(red: 0.10, green: 0.48, blue: 0.28, alpha: 1.0)
    static let gold = UIColor(red: 0.97, green: 0.80, blue: 0.27, alpha: 1.0)
    static let danger = UIColor(red: 0.88, green: 0.30, blue: 0.32, alpha: 1.0)
    static let card = UIColor.white.withAlphaComponent(0.08)
    static let cardStrong = UIColor.white.withAlphaComponent(0.14)
}

enum Theme {
    @discardableResult
    static func applyBackground(to view: UIView, top: UIColor = Palette.backgroundTop, bottom: UIColor = Palette.backgroundBottom) -> CAGradientLayer {
        view.backgroundColor = Palette.background
        let gradient = CAGradientLayer()
        gradient.colors = [top.cgColor, bottom.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    static func gradientButton(title: String, colors: [UIColor], height: CGFloat, fontSize: CGFloat, weight: UIFont.Weight = .black) -> ThemeGradientButton {
        let button = ThemeGradientButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        button.apply(colors: colors)
        button.layer.cornerRadius = 18
        button.layer.cornerCurve = .continuous
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }

    static func flatButton(title: String, height: CGFloat, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        button.backgroundColor = Palette.cardStrong
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }

    static func backButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("‹ Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}

final class ThemeGradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    func apply(colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.85 : 1.0
        }
    }
}

final class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let base = super.sizeThatFits(size)
        return CGSize(width: base.width + textInsets.left + textInsets.right,
                      height: base.height + textInsets.top + textInsets.bottom)
    }
}

final class PitchBackgroundLayer: CALayer {
    override func layoutSublayers() {
        super.layoutSublayers()
        sublayers?.forEach { $0.removeFromSuperlayer() }
        let stripeCount = 8
        let stripeWidth = bounds.width / CGFloat(stripeCount)
        for i in 0..<stripeCount where i % 2 == 0 {
            let stripe = CALayer()
            stripe.frame = CGRect(x: CGFloat(i) * stripeWidth, y: 0, width: stripeWidth, height: bounds.height)
            stripe.backgroundColor = UIColor.white.withAlphaComponent(0.018).cgColor
            addSublayer(stripe)
        }
    }
}
