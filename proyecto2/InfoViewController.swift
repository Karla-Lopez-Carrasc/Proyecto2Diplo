//
//  InfoViewController.swift
//  proyecto2
//
//  Created by Karla Lopez on 14/11/25.
//

import UIKit

final class InfoViewController: UIViewController {

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "\n\nREGLAS DEL JUEGO\n"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let rulesLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        El jugador y la computadora eligen entre piedra (✊), papel (✋) o tijera (✌️)

        • Piedra vence a tijera
        • Tijera vence a papel
        • Papel vence a piedra

        *Si ambos eligen la misma opción, es un empate.\n 
        """
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let acknowledgementsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 14)
        label.text = "Agradecimientos:\n Karla Lopez Carrasco\n\n"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarUI()
    }

    private func configurarUI() {
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            rulesLabel,
            acknowledgementsLabel
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
