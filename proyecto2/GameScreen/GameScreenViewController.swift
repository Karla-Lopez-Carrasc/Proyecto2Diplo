//
//  GameScreen.swift
//  proyecto2
//
//  Created by Karla Lopez on 14/11/25.
//
import UIKit

final class GameScreenViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var resultLabel: UILabel?
    @IBOutlet weak var counterLabel: UILabel?

    @IBOutlet weak var rockButton: UIButton?
    @IBOutlet weak var paperButton: UIButton?
    @IBOutlet weak var scissorsButton: UIButton?

    @IBOutlet weak var nextTurnButton: UIButton?
    @IBOutlet weak var resetButton: UIButton?

    var playerName: String = ""
    var mode: GameModeConfig = .rounds(targetRounds: 1)

    private var currentScore: Int = 0
    private var currentRoundsWon: Int = 0

    var history: [String] = []

    private enum Choice: CaseIterable {
        case rock, paper, scissors
    }

    // MARK: - Cargar vista desde XIB

    override func loadView() {
        Bundle.main.loadNibNamed("GameScreen", owner: self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray

        nameLabel?.text = playerName
        resultLabel?.text = "Elige una opción, \(playerName)"
        updateCounterLabel()

        hideNextTurn()
        setPlayButtons(enabled: true)

        print("⏱ Nueva partida. Historial vacío: \(history.count) entradas")
    }

    @IBAction func rockTapped(_ sender: UIButton) {
        handlePlayerChoice(.rock)
    }

    @IBAction func paperTapped(_ sender: UIButton) {
        handlePlayerChoice(.paper)
    }

    @IBAction func scissorsTapped(_ sender: UIButton) {
        handlePlayerChoice(.scissors)
    }

    // MARK: - Actions (control de juego)

    @IBAction func nextTurnTapped(_ sender: UIButton) {
        prepareForNewRound()
    }

    @IBAction func resetGameTapped(_ sender: UIButton) {
        resetGame()
    }

    @IBAction func historyTapped(_ sender: UIButton) {
        let historyVC = HistoryViewController()
        historyVC.historyText = history.joined(separator: "\n\n")
        historyVC.modalPresentationStyle = .formSheet

        if let nav = navigationController {
            nav.present(historyVC, animated: true)
        } else {
            present(historyVC, animated: true)
        }
    }

    private func handlePlayerChoice(_ playerChoice: Choice) {
        let opponentChoice = Choice.allCases.randomElement()!

        var resultText: String
        var playerWon = false
        var playerLost = false
        var roundResultDescription = ""

        switch (playerChoice, opponentChoice) {
        case let (p, o) where p == o:
            view.backgroundColor = .brown
            resultText = "Empate, \(playerName). Ambos eligieron \(emoji(for: p))."
            roundResultDescription = "Empate"

        case (.rock, .scissors),
             (.paper, .rock),
             (.scissors, .paper):
            view.backgroundColor = .systemGreen
            resultText = "¡Ganaste la ronda, \(playerName)! \(emoji(for: playerChoice)) vence a \(emoji(for: opponentChoice))."
            playerWon = true
            roundResultDescription = "Ganaste"

        default:
            view.backgroundColor = .systemRed
            resultText = "Perdiste la ronda, \(playerName). \(emoji(for: opponentChoice)) vence a \(emoji(for: playerChoice))."
            playerLost = true
            roundResultDescription = "Perdiste"
        }

        switch mode {
        case .rounds(let targetRounds):
            if playerWon {
                currentRoundsWon += 1
            }
            updateCounterLabel()

            let entry = """
            Modo: Rondas
            Resultado: \(roundResultDescription)
            Rondas ganadas: \(currentRoundsWon) / \(targetRounds)
            """
            history.append(entry)
            print("✅ Ronda registrada. Historial ahora: \(history.count) entradas")

            resultLabel?.text = resultText

            if currentRoundsWon >= targetRounds {
                showVictoryAlert(message: "¡Ganaste la partida por rondas, \(playerName)!")
                return
            }

        case .points(let winValue, let loseValue, let targetScore):
            if playerWon {
                currentScore += winValue
            } else if playerLost {
                currentScore -= loseValue
            }
            if currentScore < 0 { currentScore = 0 }

            updateCounterLabel()

            let entry = """
            Modo: Puntos
            Resultado: \(roundResultDescription)
            Puntos actuales: \(currentScore) / \(targetScore)
            """
            history.append(entry)

            resultLabel?.text = resultText

            if currentScore >= targetScore && targetScore > 0 {
                showVictoryAlert(message: "¡Ganaste la partida por puntos, \(playerName)!")
                return
            }
        }

        setPlayButtons(enabled: false)
        showNextTurn()
    }

    private func updateCounterLabel() {
        switch mode {
        case .rounds(let targetRounds):
            counterLabel?.text = "Rondas ganadas: \(currentRoundsWon) / \(targetRounds)"

        case .points(_, _, let targetScore):
            counterLabel?.text = "Puntos: \(currentScore) / \(targetScore)"
        }
    }

    private func showVictoryAlert(message: String) {
        let alert = UIAlertController(title: "Victoria", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.setPlayButtons(enabled: false)
            self.hideNextTurn()
        }))
        present(alert, animated: true)
    }

    private func emoji(for choice: Choice) -> String {
        switch choice {
        case .rock: return "✊"
        case .paper: return "✋"
        case .scissors: return "✌️"
        }
    }

    private func setPlayButtons(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        [rockButton, paperButton, scissorsButton].forEach { button in
            button?.isEnabled = enabled
            button?.alpha = alpha
        }
    }

    private func showNextTurn() {
        nextTurnButton?.isHidden = false
        nextTurnButton?.isEnabled = true
    }

    private func hideNextTurn() {
        nextTurnButton?.isHidden = true
        nextTurnButton?.isEnabled = false
    }

    private func prepareForNewRound() {
        view.backgroundColor = .systemGray
        resultLabel?.text = "Elige una opción, \(playerName)"
        setPlayButtons(enabled: true)
        hideNextTurn()
    }

    private func resetGame() {
        currentScore = 0
        currentRoundsWon = 0
        history.removeAll()

        view.backgroundColor = .systemGray
        resultLabel?.text = "Elige una opción, \(playerName)"
        updateCounterLabel()

        setPlayButtons(enabled: true)
        hideNextTurn()
    }
}
