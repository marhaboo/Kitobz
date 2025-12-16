//
//  LeaveReviewViewController.swift
//  Kitobz
//
//  Created by Boymurodova Marhabo on 16/12/25.
//

import UIKit
import SnapKit

final class LeaveReviewViewController: UIViewController {
    
    var bookTitle: String = ""
    var onReviewSubmitted: ((Int, String) -> Void)?
    
    private var selectedRating: Int = 0
    
    // MARK: - Views
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.layer.masksToBounds = true
        return v
    }()
    
    private let closeButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        b.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        b.tintColor = .label
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .center
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    private let ratingQuestionLabel: UILabel = {
        let l = UILabel()
        l.text = "Вам понравилась книга?"
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    
    private let starsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalSpacing
        s.spacing = 12
        return s
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.textColor = .label
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        tv.layer.cornerRadius = 12
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.isScrollEnabled = true
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.text = "Поделитесь своим мнением о книге..."
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .placeholderText
        l.numberOfLines = 0
        return l
    }()
    
    private let characterCountLabel: UILabel = {
        let l = UILabel()
        l.text = "0/120"
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let minCharLabel: UILabel = {
        let l = UILabel()
        l.text = "Минимальный размер отзыва"
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()
    
    // Keyboard toolbar with Готово button
    private lazy var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(didTapKeyboardDone))
        
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }()
    
    private let submitButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Отправить отзыв", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        b.layer.cornerRadius = 12
        b.isEnabled = false
        return b
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setupViews()
        setupStars()
        setupLayout()
        setupActions()
        
        titleLabel.text = bookTitle
        
        textView.delegate = self
        textView.inputAccessoryView = keyboardToolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Listen for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(containerView)
        
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ratingQuestionLabel)
        containerView.addSubview(starsStack)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(minCharLabel)
        containerView.addSubview(characterCountLabel)
        containerView.addSubview(submitButton)
    }
    
    private func setupStars() {
        for i in 1...5 {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
            button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
            button.tintColor = .systemOrange
            button.tag = i
            button.addTarget(self, action: #selector(didTapStar(_:)), for: .touchUpInside)
            starsStack.addArrangedSubview(button)
        }
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalTo(closeButton.snp.leading).offset(-8)
            make.centerX.equalToSuperview()
        }
        
        ratingQuestionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        starsStack.snp.makeConstraints { make in
            make.top.equalTo(ratingQuestionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(starsStack.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(200)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView).offset(16)
            make.leading.equalTo(textView).offset(16)
            make.trailing.equalTo(textView).inset(16)
        }
        
        minCharLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.leading.equalTo(textView)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.trailing.equalTo(textView)
        }
        
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func didTapStar(_ sender: UIButton) {
        selectedRating = sender.tag
        updateStars()
        updateSubmitButton()
    }
    
    @objc private func didTapClose() {
        view.endEditing(true)
        animateOut {
            self.dismiss(animated: false)
        }
    }
    
    @objc private func didTapSubmit() {
        view.endEditing(true)
        
        let reviewText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        onReviewSubmitted?(selectedRating, reviewText)
        
        animateOut {
            self.dismiss(animated: false)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapKeyboardDone() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.submitButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight + 8)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.submitButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Helpers
    
    private func updateStars() {
        for (index, view) in starsStack.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            let starIndex = index + 1
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
            let imageName = starIndex <= selectedRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        }
    }
    
    private func updateSubmitButton() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasMinChars = text.count >= 10
        let hasRating = selectedRating > 0
        
        submitButton.isEnabled = hasMinChars && hasRating
        submitButton.backgroundColor = submitButton.isEnabled ? .systemBlue : .systemGray4
    }
    
    private func animateIn() {
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
        }
    }
    
    private func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
            self.view.backgroundColor = .clear
        } completion: { _ in
            completion()
        }
    }
}

// MARK: - UITextViewDelegate

extension LeaveReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        let count = text.count
        
        characterCountLabel.text = "\(count)/120"
        placeholderLabel.isHidden = !text.isEmpty
        
        updateSubmitButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 120
    }
}
