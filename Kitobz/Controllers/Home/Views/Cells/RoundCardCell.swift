//
//  RoundCardCell.swift
//  Kitobz
//
//  Created by Boymuroдова Марhabo on 03/12/25.
//

import UIKit
import SnapKit

final class RoundCardCell: UICollectionViewCell {

    static let identifier = "RoundCardCell"

    // MARK: - Views
    private let circleContainer = UIView()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()

    // MARK: - Layers
    private let gradientRing = CAGradientLayer()
    private let gradientMask = CAShapeLayer()
    private let innerRing = CAShapeLayer()
    private let grayRing = CAShapeLayer()

    // MARK: - Metrics
    private let circleDiameter: CGFloat = 96
    private let outerRingWidth: CGFloat = 3
    private let innerRingWidth: CGFloat = 2

    private var isLayersSetup = false
    private var seen: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(circleContainer)
        contentView.addSubview(titleLabel)
        circleContainer.addSubview(imageView)

        circleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(circleDiameter)
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(circleContainer.snp.width).multipliedBy(0.78)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleContainer.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        contentView.layoutIfNeeded()
        setupLayersIfNeeded()
        updateLayersGeometryIfPossible()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupLayersIfNeeded()
        updateLayersGeometryIfPossible()
    }

    private func setupLayersIfNeeded() {
        guard !isLayersSetup else { return }

        circleContainer.backgroundColor = .systemBackground
        circleContainer.layer.masksToBounds = true

        let scale = UIScreen.main.scale
        gradientRing.contentsScale = scale
        gradientMask.contentsScale = scale
        innerRing.contentsScale = scale
        grayRing.contentsScale = scale

        // Gradient outer ring (unseen)
        gradientRing.startPoint = CGPoint(x: 0, y: 0)
        gradientRing.endPoint = CGPoint(x: 1, y: 1)
        gradientRing.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.magenta.withAlphaComponent(0.9).cgColor
        ]
        gradientRing.locations = [0, 0.5, 1]
        gradientRing.type = .axial

        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = outerRingWidth
        gradientMask.lineCap = .round
        gradientRing.mask = gradientMask

        // Inner light ring
        innerRing.fillColor = UIColor.clear.cgColor
        innerRing.strokeColor = UIColor.systemGray4.cgColor
        innerRing.lineWidth = innerRingWidth

        // Gray ring (seen)
        grayRing.fillColor = UIColor.clear.cgColor
        grayRing.strokeColor = UIColor.systemGray3.cgColor
        grayRing.lineWidth = outerRingWidth
        grayRing.lineCap = .round
        grayRing.isHidden = true

        gradientRing.zPosition = 1
        grayRing.zPosition = 1
        innerRing.zPosition = 2
        imageView.layer.zPosition = 0

        circleContainer.layer.addSublayer(gradientRing)
        circleContainer.layer.addSublayer(grayRing)
        circleContainer.layer.addSublayer(innerRing)

        isLayersSetup = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayersGeometryIfPossible()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }

    private func updateLayersGeometryIfPossible() {
        let bounds = circleContainer.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }

        circleContainer.layer.cornerRadius = bounds.width / 2

        gradientRing.frame = bounds

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (bounds.width - outerRingWidth) / 2

        let ringPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        gradientMask.path = ringPath.cgPath

        let innerRadius = radius - 5
        let innerPath = UIBezierPath(
            arcCenter: center,
            radius: innerRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        innerRing.path = innerPath.cgPath

        let grayPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        grayRing.path = grayPath.cgPath

        applySeenState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        seen = false
        applySeenState()
    }

    func configure(with item: RoundCardItem, seen: Bool = false) {
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        self.seen = seen
        setNeedsLayout()
    }

    func setSeen(_ seen: Bool) {
        self.seen = seen
        applySeenState()
    }

    private func applySeenState() {
        gradientRing.isHidden = seen
        gradientRing.mask?.isHidden = seen
        grayRing.isHidden = !seen
    }
}

