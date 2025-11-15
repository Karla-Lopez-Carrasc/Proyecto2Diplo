//
//  HistoryViewController.swift
//  proyecto2
//
//  Created by Karla Lopez on 14/11/25.
//

import UIKit

final class HistoryViewController: UIViewController {

    var historyText: String = ""

    private let textView = UITextView()
    private let closeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Cerrar", for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        view.addSubview(closeButton)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.text = historyText.isEmpty
            ? "No hay jugadas registradas todavía."
            : historyText
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func closePressed() {
        dismiss(animated: true)
    }
}
