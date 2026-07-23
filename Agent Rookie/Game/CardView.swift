import UIKit

final class CardView: UIView {

    private(set) var card: TransferCard?

    private let gradientLayer = CAGradientLayer()

    private let ovrLabel = UILabel()
    private let ovrCaptionLabel = UILabel()
    private let positionChip = UILabel()
    private let kindBadge = UILabel()

    private let avatarView = UIView()
    private let avatarInitials = UILabel()

    private let nameLabel = UILabel()
    private let detailLabel = UILabel()

    private let priceTitleLabel = UILabel()
    private let priceLabel = UILabel()

    private let hintLabel = UILabel()

    private let leftOverlay = UILabel()
    private let rightOverlay = UILabel()


    // MARK: - Responsive scale

    private var scaleFactor: CGFloat {
        let baseWidth: CGFloat = 390
        let value = bounds.width / baseWidth

        return max(
            0.85,
            min(value, 1.45)
        )
    }


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds

        avatarView.layer.cornerRadius =
        avatarView.bounds.width / 2

        applyResponsiveScale()
    }


    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)

        setNeedsLayout()
    }


    // MARK: - Setup

    private func setupView() {

        backgroundColor = .clear

        layer.cornerRadius = 26
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.45
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(
            width: 0,
            height: 12
        )


        let content = UIView()

        content.translatesAutoresizingMaskIntoConstraints = false

        content.layer.cornerRadius = 26
        content.layer.cornerCurve = .continuous

        content.layer.borderWidth = 1.5
        content.layer.borderColor =
        UIColor.white
            .withAlphaComponent(0.14)
            .cgColor

        content.clipsToBounds = true

        addSubview(content)


        gradientLayer.startPoint =
        CGPoint(
            x: 0,
            y: 0
        )

        gradientLayer.endPoint =
        CGPoint(
            x: 1,
            y: 1
        )

        content.layer.insertSublayer(
            gradientLayer,
            at: 0
        )


        setupLabels()


        avatarView.backgroundColor =
        UIColor.white
            .withAlphaComponent(0.15)

        avatarView.translatesAutoresizingMaskIntoConstraints = false


        avatarInitials.textAlignment = .center
        avatarInitials.textColor = .white
        avatarInitials.translatesAutoresizingMaskIntoConstraints = false


        avatarView.addSubview(
            avatarInitials
        )


        [
            ovrLabel,
            ovrCaptionLabel,
            positionChip,
            kindBadge,
            avatarView,
            nameLabel,
            detailLabel,
            priceTitleLabel,
            priceLabel,
            hintLabel
        ]
            .forEach {
                content.addSubview($0)
            }


        setupOverlay(
            leftOverlay,
            rotation: -0.2
        )

        setupOverlay(
            rightOverlay,
            rotation: 0.2
        )


        content.addSubview(leftOverlay)
        content.addSubview(rightOverlay)



        NSLayoutConstraint.activate([


            // Content

            content.topAnchor.constraint(
                equalTo: topAnchor
            ),

            content.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),

            content.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            content.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),



            // OVR

            ovrLabel.topAnchor.constraint(
                equalTo: content.topAnchor,
                constant: 18
            ),

            ovrLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),



            ovrCaptionLabel.topAnchor.constraint(
                equalTo: ovrLabel.bottomAnchor,
                constant: -8
            ),

            ovrCaptionLabel.centerXAnchor.constraint(
                equalTo: ovrLabel.centerXAnchor
            ),



            positionChip.topAnchor.constraint(
                equalTo: ovrCaptionLabel.bottomAnchor,
                constant: 8
            ),

            positionChip.centerXAnchor.constraint(
                equalTo: ovrLabel.centerXAnchor
            ),

            positionChip.widthAnchor.constraint(
                equalToConstant: 60
            ),

            positionChip.heightAnchor.constraint(
                equalToConstant: 26
            ),



            // Badge

            kindBadge.topAnchor.constraint(
                equalTo: content.topAnchor,
                constant: 22
            ),

            kindBadge.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),

            kindBadge.heightAnchor.constraint(
                equalToConstant: 24
            ),

            kindBadge.widthAnchor.constraint(
                greaterThanOrEqualToConstant: 120
            ),



            // Avatar

            avatarView.topAnchor.constraint(
                equalTo: content.topAnchor,
                constant: 96
            ),

            avatarView.centerXAnchor.constraint(
                equalTo: content.centerXAnchor
            ),

            avatarView.widthAnchor.constraint(
                equalTo: content.widthAnchor,
                multiplier: 0.30
            ),

            avatarView.heightAnchor.constraint(
                equalTo: avatarView.widthAnchor
            ),



            avatarInitials.centerXAnchor.constraint(
                equalTo: avatarView.centerXAnchor
            ),

            avatarInitials.centerYAnchor.constraint(
                equalTo: avatarView.centerYAnchor
            ),



            // Name

            nameLabel.topAnchor.constraint(
                equalTo: avatarView.bottomAnchor,
                constant: 18
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),

            nameLabel.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),



            // Detail

            detailLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 6
            ),

            detailLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),

            detailLabel.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),
			
			            // Price title

            priceTitleLabel.topAnchor.constraint(
                equalTo: detailLabel.bottomAnchor,
                constant: 22
            ),

            priceTitleLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),

            priceTitleLabel.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),



            // Price

            priceLabel.topAnchor.constraint(
                equalTo: priceTitleLabel.bottomAnchor,
                constant: 2
            ),

            priceLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),

            priceLabel.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),



            // Hint

            hintLabel.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 20
            ),

            hintLabel.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -20
            ),

            hintLabel.bottomAnchor.constraint(
                equalTo: content.bottomAnchor,
                constant: -18
            ),



            // Overlay

            leftOverlay.topAnchor.constraint(
                equalTo: content.topAnchor,
                constant: 28
            ),

            leftOverlay.leadingAnchor.constraint(
                equalTo: content.leadingAnchor,
                constant: 22
            ),


            rightOverlay.topAnchor.constraint(
                equalTo: content.topAnchor,
                constant: 28
            ),

            rightOverlay.trailingAnchor.constraint(
                equalTo: content.trailingAnchor,
                constant: -22
            )

        ])
    }



    private func setupLabels() {

        ovrLabel.textColor = .white
        ovrLabel.textAlignment = .center
        ovrLabel.translatesAutoresizingMaskIntoConstraints = false


        ovrCaptionLabel.text = "OVR"
        ovrCaptionLabel.textColor =
        UIColor.white.withAlphaComponent(0.85)

        ovrCaptionLabel.textAlignment = .center
        ovrCaptionLabel.translatesAutoresizingMaskIntoConstraints = false



        positionChip.textColor = .white
        positionChip.textAlignment = .center

        positionChip.layer.cornerRadius = 8
        positionChip.clipsToBounds = true

        positionChip.translatesAutoresizingMaskIntoConstraints = false



        kindBadge.textColor = .white
        kindBadge.textAlignment = .center

        kindBadge.layer.cornerRadius = 10
        kindBadge.clipsToBounds = true

        kindBadge.numberOfLines = 1

        kindBadge.translatesAutoresizingMaskIntoConstraints = false



        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        nameLabel.numberOfLines = 1

        nameLabel.translatesAutoresizingMaskIntoConstraints = false



        detailLabel.textColor =
        UIColor.white.withAlphaComponent(0.85)

        detailLabel.textAlignment = .center
        detailLabel.translatesAutoresizingMaskIntoConstraints = false



        priceTitleLabel.textColor =
        UIColor.white.withAlphaComponent(0.7)

        priceTitleLabel.textAlignment = .center
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false



        priceLabel.textColor = .white
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false



        hintLabel.textColor =
        UIColor.white.withAlphaComponent(0.6)

        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 2

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
    }



    private func applyResponsiveScale() {

        let scale = scaleFactor


        ovrLabel.font =
        UIFont.systemFont(
            ofSize: 56 * scale,
            weight: .black
        )


        ovrCaptionLabel.font =
        UIFont.systemFont(
            ofSize: 14 * scale,
            weight: .heavy
        )


        positionChip.font =
        UIFont.systemFont(
            ofSize: 15 * scale,
            weight: .bold
        )


        kindBadge.font =
        UIFont.systemFont(
            ofSize: 12 * scale,
            weight: .heavy
        )


        avatarInitials.font =
        UIFont.systemFont(
            ofSize: 40 * scale,
            weight: .black
        )


        nameLabel.font =
        UIFont.systemFont(
            ofSize: 28 * scale,
            weight: .heavy
        )


        detailLabel.font =
        UIFont.systemFont(
            ofSize: 16 * scale,
            weight: .semibold
        )


        priceTitleLabel.font =
        UIFont.systemFont(
            ofSize: 13 * scale,
            weight: .bold
        )


        priceLabel.font =
        UIFont.systemFont(
            ofSize: 30 * scale,
            weight: .black
        )


        hintLabel.font =
        UIFont.systemFont(
            ofSize: 13 * scale,
            weight: .semibold
        )


        leftOverlay.font =
        UIFont.systemFont(
            ofSize: 26 * scale,
            weight: .black
        )


        rightOverlay.font =
        UIFont.systemFont(
            ofSize: 26 * scale,
            weight: .black
        )
    }



    private func setupOverlay(
        _ label: UILabel,
        rotation: CGFloat
    ) {

        label.textColor = .white
        label.textAlignment = .center

        label.layer.cornerRadius = 10
        label.clipsToBounds = true

        label.alpha = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        label.transform =
        CGAffineTransform(
            rotationAngle: rotation
        )


        label.widthAnchor.constraint(
            greaterThanOrEqualToConstant: 130
        ).isActive = true


        label.heightAnchor.constraint(
            equalToConstant: 46
        ).isActive = true
    }



    // MARK: - Configure


    func configure(with card: TransferCard) {

        self.card = card


        ovrLabel.text = "\(card.ovr)"
        ovrLabel.textColor =
        CardView.ovrColor(card.ovr)


        positionChip.text = card.position
        positionChip.backgroundColor =
        CardView.positionColor(card.position)


        nameLabel.text = card.name


        detailLabel.text =
        "\(card.position) · Age \(card.age)"


        priceLabel.text =
        "$\(card.price)M"


        avatarInitials.text =
        CardView.initials(
            from: card.name
        )



        switch card.kind {


        case .rookie:

            gradientLayer.colors = [
                UIColor(
                    red: 0.10,
                    green: 0.42,
                    blue: 0.30,
                    alpha: 1
                ).cgColor,

                UIColor(
                    red: 0.05,
                    green: 0.22,
                    blue: 0.18,
                    alpha: 1
                ).cgColor
            ]


            kindBadge.text =
            "  ROOKIE · ON THE MARKET  "


            kindBadge.backgroundColor =
            UIColor(
                red: 0.18,
                green: 0.65,
                blue: 0.40,
                alpha: 1
            )


            priceTitleLabel.text =
            "ASKING PRICE"


            hintLabel.text =
            "Swipe LEFT to BUY  ·  Swipe RIGHT to PASS"



            configureOverlay(
                leftOverlay,
                text: "BUY",
                color: UIColor(
                    red: 0.18,
                    green: 0.75,
                    blue: 0.42,
                    alpha: 0.95
                )
            )


            configureOverlay(
                rightOverlay,
                text: "PASS",
                color: UIColor(
                    white: 0.45,
                    alpha: 0.95
                )
            )



        case .veteran:

            gradientLayer.colors = [
                UIColor(
                    red: 0.40,
                    green: 0.20,
                    blue: 0.10,
                    alpha: 1
                ).cgColor,

                UIColor(
                    red: 0.20,
                    green: 0.10,
                    blue: 0.06,
                    alpha: 1
                ).cgColor
            ]


            kindBadge.text =
            "  VETERAN · BID RECEIVED  "


            kindBadge.backgroundColor =
            UIColor(
                red: 0.78,
                green: 0.42,
                blue: 0.18,
                alpha: 1
            )


            priceTitleLabel.text =
            "INCOMING BID"


            hintLabel.text =
            "Swipe RIGHT to SELL  ·  Swipe LEFT to KEEP"



            configureOverlay(
                leftOverlay,
                text: "KEEP",
                color: UIColor(
                    white: 0.45,
                    alpha: 0.95
                )
            )


            configureOverlay(
                rightOverlay,
                text: "SELL",
                color: UIColor(
                    red: 0.85,
                    green: 0.28,
                    blue: 0.30,
                    alpha: 0.95
                )
            )
        }


        leftOverlay.alpha = 0
        rightOverlay.alpha = 0
    }



    private func configureOverlay(
        _ label: UILabel,
        text: String,
        color: UIColor
    ) {

        label.text = "  \(text)  "
        label.backgroundColor = color
    }



    func updateOverlay(
        forTranslation tx: CGFloat,
        threshold: CGFloat
    ) {

        let progress =
        min(
            1,
            abs(tx) / threshold
        )


        if tx < 0 {

            leftOverlay.alpha = progress
            rightOverlay.alpha = 0

        } else if tx > 0 {

            rightOverlay.alpha = progress
            leftOverlay.alpha = 0

        } else {

            leftOverlay.alpha = 0
            rightOverlay.alpha = 0
        }
    }



    func resetOverlay() {

        leftOverlay.alpha = 0
        rightOverlay.alpha = 0
    }



    static func positionColor(
        _ position: String
    ) -> UIColor {

        switch position {

        case "GK":
            return UIColor(
                red: 0.95,
                green: 0.75,
                blue: 0.15,
                alpha: 1
            )

        case "DEF":
            return UIColor(
                red: 0.25,
                green: 0.55,
                blue: 0.95,
                alpha: 1
            )

        case "MID":
            return UIColor(
                red: 0.30,
                green: 0.75,
                blue: 0.45,
                alpha: 1
            )

        default:
            return UIColor(
                red: 0.90,
                green: 0.35,
                blue: 0.40,
                alpha: 1
            )
        }
    }



    static func ovrColor(
        _ ovr: Int
    ) -> UIColor {

        switch ovr {

        case 85...:
            return UIColor(
                red: 1,
                green: 0.84,
                blue: 0.30,
                alpha: 1
            )

        case 75..<85:
            return UIColor(
                red: 0.55,
                green: 0.95,
                blue: 0.6,
                alpha: 1
            )

        case 65..<75:
            return .white

        default:
            return UIColor.white.withAlphaComponent(0.8)
        }
    }



    static func initials(
        from name: String
    ) -> String {

        let parts =
        name.split(
            separator: " "
        )


        let letters =
        parts.prefix(2)
            .compactMap {
                $0.first
            }


        return String(letters)
            .uppercased()
    }
}
