//
//  StoriesViewerViewController.swift
//  Kitobz
//
//  Created by Boymuroдова Marhabo on 08/12/25.
//

import UIKit
import SnapKit
import WebKit
import SwiftyGif

final class StoriesViewerViewController: UIViewController {

    // MARK: - Public
    var onFinished: (() -> Void)?
    var onRequestNextStory: (() -> Void)?

    // MARK: - Data
    private let story: Story
    private var currentIndex: Int = 0
    private var timer: Timer?

    // MARK: - UI
    private let imageContainer = UIView()
    private let imageView = UIImageView()

    private let closeButton = UIButton(type: .system)
    private let ctaButton = UIButton(type: .system)

    private var progressBars: [UIProgressView] = []
    private let progressStack = UIStackView()

    // Config
    private let slideDuration: TimeInterval = 4.0

    // MARK: - Init
    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupUI()
        setupGestures()
        setupProgressBars()

        showMedia(at: 0, animated: false)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        progressStack.axis = .horizontal
        progressStack.spacing = 6
        progressStack.distribution = .fillEqually
        view.addSubview(progressStack)
        progressStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(4)
        }

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 16
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }

        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.filled()
            conf.title = "ПОСЕТИТЬ ССЫЛКУ"
            conf.baseBackgroundColor = .white
            conf.baseForegroundColor = .black
            conf.cornerStyle = .large
            ctaButton.configuration = conf
        } else {
            ctaButton.setTitle("ПОСЕТИТЬ ССЫЛКУ", for: .normal)
            ctaButton.setTitleColor(.black, for: .normal)
            ctaButton.backgroundColor = .white
            ctaButton.layer.cornerRadius = 12
            ctaButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }

        ctaButton.isHidden = (story.link == nil)
        ctaButton.addTarget(self, action: #selector(ctaTapped), for: .touchUpInside)
        view.addSubview(ctaButton)
        ctaButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.height.equalTo(52)
        }
    }

    private func setupProgressBars() {
        progressBars.removeAll()
        progressStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let count = max(1, story.images.count)
        for _ in 0..<count {
            let bar = UIProgressView(progressViewStyle: .bar)
            bar.trackTintColor = UIColor.white.withAlphaComponent(0.3)
            bar.progressTintColor = .white
            bar.clipsToBounds = true
            bar.layer.cornerRadius = 2
            bar.progress = 0
            progressBars.append(bar)
            progressStack.addArrangedSubview(bar)
        }
    }

    // MARK: - Load Image/GIF
    private func showMedia(at index: Int, animated: Bool) {
        guard !story.images.isEmpty else { return }

        let idx = max(0, min(index, story.images.count - 1))
        currentIndex = idx
        let name = story.images[idx]

        // --------------- GIF FROM ASSETS SUPPORT ---------------
        imageView.clear()

        if let dataAsset = NSDataAsset(name: name) {
            if let gif = try? UIImage(gifData: dataAsset.data) {
                imageView.setGifImage(gif, loopCount: -1)
            }
        } else if let image = UIImage(named: name) {
            imageView.image = image
        } else {
            print("⚠️ Asset not found: \(name)")
        }
        // --------------------------------------------------------

        // Layout logic
        if idx == 0 {
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .black
            imageView.clipsToBounds = false

            imageContainer.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualTo(view).offset(16)
                make.trailing.lessThanOrEqualTo(view).offset(-16)
                make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top).offset(60)
                make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            }
        } else {
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
            imageView.clipsToBounds = true

            imageContainer.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            }
        }

        if animated {
            UIView.transition(with: imageView, duration: 0.25, options: .transitionCrossDissolve) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }

        updateProgressBars()

        view.bringSubviewToFront(progressStack)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(ctaButton)
    }

    private func updateProgressBars() {
        for (i, bar) in progressBars.enumerated() {
            bar.progress = i < currentIndex ? 1 : 0
        }
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        guard !story.images.isEmpty else { return }

        let step: Float = 1.0 / Float(slideDuration * 20.0)
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let bar = self.progressBars[self.currentIndex]
            bar.progress = min(1.0, bar.progress + step)

            if bar.progress >= 1.0 {
                self.advance()
            }
        }
        if let timer { RunLoop.main.add(timer, forMode: .common) }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func advance() {
        if currentIndex + 1 < story.images.count {
            showMedia(at: currentIndex + 1, animated: true)
            startTimer()
        } else if let onRequestNextStory {
            stopTimer()
            dismiss(animated: true) { onRequestNextStory() }
        } else {
            finish()
        }
    }

    private func back() {
        if currentIndex > 0 {
            showMedia(at: currentIndex - 1, animated: true)
            startTimer()
        } else {
            finish()
        }
    }

    // MARK: - Gestures
    private func setupGestures() {
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleHold(_:)))
        holdGesture.minimumPressDuration = 0.1
        view.addGestureRecognizer(holdGesture)

        let leftView = UIView()
        let rightView = UIView()
        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear
        view.addSubview(leftView)
        view.addSubview(rightView)

        leftView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        rightView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))

        view.sendSubviewToBack(rightView)
        view.sendSubviewToBack(leftView)
        view.sendSubviewToBack(imageContainer)
    }

    // MARK: - Actions
    @objc private func didTapLeft() {
        stopTimer()
        back()
    }

    @objc private func didTapRight() {
        stopTimer()
        advance()
    }

    @objc private func closeTapped() {
        finish()
    }

    @objc private func ctaTapped() {
        guard let url = story.link else { return }
        UIApplication.shared.open(url)
    }

    private func finish() {
        stopTimer()
        dismiss(animated: true) { [weak self] in
            self?.onFinished?()
        }
    }

    @objc private func handleHold(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            stopTimer()
        case .ended, .cancelled:
            startTimer()
        default:
            break
        }
    }
}
