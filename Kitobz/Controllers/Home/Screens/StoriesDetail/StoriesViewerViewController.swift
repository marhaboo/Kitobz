//
//  StoriesViewerViewController.swift
//  Kitobz
//
//  Created by Boymuroдова Marhabo on 08/12/25.
//

import UIKit

final class StoriesViewerViewController: UIViewController {

    // MARK: - Public
    var onFinished: (() -> Void)?

    // MARK: - Data
    private let story: Story
    private var currentIndex: Int = 0
    private var timer: Timer?

    // MARK: - UI
    private let imageView = UIImageView()
    private let closeButton = UIButton(type: .system)
    private let ctaButton = UIButton(type: .system)
    private var progressBars: [UIProgressView] = []
    private let progressStack = UIStackView()

    // Config
    private let slideDuration: TimeInterval = 4.0

    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupGestures()
        setupProgressBars()
        showImage(at: 0, animated: false)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        progressStack.axis = .horizontal
        progressStack.alignment = .fill
        progressStack.distribution = .fillEqually
        progressStack.spacing = 6

        view.addSubview(progressStack)
        progressStack.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // CTA: ПОСЕТИТЬ ССЫЛКУ
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.filled()
            conf.baseBackgroundColor = .white
            conf.baseForegroundColor = .black
            conf.cornerStyle = .large
            conf.title = "ПОСЕТИТЬ ССЫЛКУ"
            ctaButton.configuration = conf
        } else {
            ctaButton.setTitle("ПОСЕТИТЬ ССЫЛКУ", for: .normal)
            ctaButton.setTitleColor(.black, for: .normal)
            ctaButton.backgroundColor = .white
            ctaButton.layer.cornerRadius = 12
            ctaButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
        ctaButton.addTarget(self, action: #selector(ctaTapped), for: .touchUpInside)
        ctaButton.isHidden = (story.link == nil)
        view.addSubview(ctaButton)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            progressStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            progressStack.heightAnchor.constraint(equalToConstant: 4),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            ctaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ctaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            ctaButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupProgressBars() {
        progressBars.forEach { $0.removeFromSuperview() }
        progressBars.removeAll()
        let count = max(1, story.images.count)
        for _ in 0..<count {
            let bar = UIProgressView(progressViewStyle: .bar)
            bar.trackTintColor = UIColor.white.withAlphaComponent(0.3)
            bar.progressTintColor = .white
            bar.progress = 0
            bar.layer.cornerRadius = 2
            bar.clipsToBounds = true
            progressBars.append(bar)
            progressStack.addArrangedSubview(bar)
        }
    }

    private func setupGestures() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(didTapLeft))
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(didTapRight))
        leftTap.require(toFail: rightTap)

        let leftView = UIView()
        let rightView = UIView()
        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear

        view.addSubview(leftView)
        view.addSubview(rightView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: view.topAnchor),
            leftView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            rightView.topAnchor.constraint(equalTo: view.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])

        leftView.addGestureRecognizer(leftTap)
        rightView.addGestureRecognizer(rightTap)
    }

    private func showImage(at index: Int, animated: Bool) {
        guard !story.images.isEmpty else { return }
        let idx = max(0, min(index, story.images.count - 1))
        currentIndex = idx
        let image = UIImage(named: story.images[idx])

        if animated {
            UIView.transition(with: imageView, duration: 0.25, options: .transitionCrossDissolve) {
                self.imageView.image = image
            }
        } else {
            imageView.image = image
        }

        updateProgressBars()
    }

    private func updateProgressBars() {
        for (i, bar) in progressBars.enumerated() {
            if i < currentIndex {
                bar.progress = 1
            } else if i == currentIndex {
                bar.progress = 0
            } else {
                bar.progress = 0
            }
        }
    }

    private func startTimer() {
        stopTimer()
        guard !story.images.isEmpty else { return }
        let step: Float = 1.0 / Float(slideDuration * 20.0) // 20 ticks per second
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] t in
            guard let self = self else { return }
            let bar = self.progressBars[self.currentIndex]
            bar.progress = min(1.0, bar.progress + step)
            if bar.progress >= 1.0 {
                self.advance()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func advance() {
        if currentIndex + 1 < story.images.count {
            showImage(at: currentIndex + 1, animated: true)
            startTimer()
        } else {
            finish()
        }
    }

    private func back() {
        if currentIndex > 0 {
            showImage(at: currentIndex - 1, animated: true)
            startTimer()
        } else {
            // At first image: close on back tap (common UX)
            finish()
        }
    }

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
}

