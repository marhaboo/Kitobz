//
//  GlassButtonContainer.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 10/12/25.
//

import UIKit

final class GlassButtonContainer: UIView {

    private let gradientLayer = CAGradientLayer()
    private let borderShapeLayer = CAShapeLayer()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let contentButton: UIButton

    var cornerRadius: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }

    init(button: UIButton, size: CGFloat = 40) {
        self.contentButton = button
        super.init(frame: .zero)
        setupViews()
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        // Blur
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.clipsToBounds = true
        addSubview(blurView)

        // Button
        contentButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentButton)
        NSLayoutConstraint.activate([
            contentButton.topAnchor.constraint(equalTo: topAnchor),
            contentButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Gradient border
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)

        // Border mask
        borderShapeLayer.lineWidth = 1.5
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.strokeColor = UIColor.black.cgColor // temporary
        gradientLayer.mask = borderShapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = bounds

        // Blur
        blurView.frame = rect
        blurView.layer.cornerRadius = rect.height / 2

        // Gradient
        gradientLayer.frame = rect

        // Shape for circular border
        borderShapeLayer.frame = rect
        borderShapeLayer.path = UIBezierPath(ovalIn: rect).cgPath
    }
}
