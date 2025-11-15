import UIKit

enum GameModeConfig {
    case rounds(targetRounds: Int)
    case points(winValue: Int, loseValue: Int, targetScore: Int)
}

final class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreTF: UITextField!

    @IBOutlet weak var modeSC: UISegmentedControl!

    @IBOutlet weak var rondaSlider: UISlider!
    @IBOutlet weak var rondaLabel: UILabel!

    @IBOutlet weak var valorGanadoTF: UITextField!
    @IBOutlet weak var valorPerdidaTF: UITextField!
    @IBOutlet weak var puntajeRequeridoTF: UITextField!

    @IBOutlet weak var continuarBtn: UIButton!


    var gameModeConfig: GameModeConfig = .rounds(targetRounds: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurarUI()
        configurarValidaciones()
        actualizarModo()
        validarCampos()

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingNow))
        view.addGestureRecognizer(tap)
    }

    private func configurarUI() {
        // Slider
        rondaSlider.minimumValue = 1
        rondaSlider.maximumValue = 5
        rondaSlider.value = 1
        rondaLabel.text = "\(Int(rondaSlider.value))"

        rondaSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)

        valorGanadoTF.keyboardType = .numberPad
        valorPerdidaTF.keyboardType = .numberPad
        puntajeRequeridoTF.keyboardType = .numberPad

        valorGanadoTF.delegate = self
        valorPerdidaTF.delegate = self
        puntajeRequeridoTF.delegate = self

        continuarBtn.alpha = 0.4
        continuarBtn.isEnabled = false
    }

    private func configurarValidaciones() {
        nombreTF.addTarget(self, action: #selector(validarCampos), for: .editingChanged)
        valorGanadoTF.addTarget(self, action: #selector(validarCampos), for: .editingChanged)
        valorPerdidaTF.addTarget(self, action: #selector(validarCampos), for: .editingChanged)
        puntajeRequeridoTF.addTarget(self, action: #selector(validarCampos), for: .editingChanged)
    }

    private func actualizarModo() {
        if modeSC.selectedSegmentIndex == 0 {
            // RONDAS
            rondaSlider.isHidden = false
            rondaLabel.isHidden = false

            valorGanadoTF.isHidden = true
            valorPerdidaTF.isHidden = true
            puntajeRequeridoTF.isHidden = true

        } else {
            // PUNTOS
            rondaSlider.isHidden = true
            rondaLabel.isHidden = true

            valorGanadoTF.isHidden = false
            valorPerdidaTF.isHidden = false
            puntajeRequeridoTF.isHidden = false
        }

        validarCampos()
    }

    @objc private func validarCampos() {
        let nombreOK = !(nombreTF.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty

        if !nombreOK {
            bloquearBoton()
            return
        }

        if modeSC.selectedSegmentIndex == 0 {
            activarBoton()
        } else {
            // modo puntos: los 3 campos llenos
            let lleno1 = !(valorGanadoTF.text ?? "").isEmpty
            let lleno2 = !(valorPerdidaTF.text ?? "").isEmpty
            let lleno3 = !(puntajeRequeridoTF.text ?? "").isEmpty

            if lleno1 && lleno2 && lleno3 {
                activarBoton()
            } else {
                bloquearBoton()
            }
        }
    }

    private func activarBoton() {
        continuarBtn.alpha = 1.0
        continuarBtn.isEnabled = true
    }

    private func bloquearBoton() {
        continuarBtn.alpha = 0.4
        continuarBtn.isEnabled = false
    }


    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        actualizarModo()
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value = round(sender.value)
        let value = Int(sender.value)
        rondaLabel.text = "\(value)"
    }

    @IBAction func continuarPressed(_ sender: UIButton) {
        let nombre = (nombreTF.text ?? "").trimmingCharacters(in: .whitespaces)
        guard !nombre.isEmpty else { return }

        if modeSC.selectedSegmentIndex == 0 {
            // MODO RONDAS
            let target = Int(rondaSlider.value)
            gameModeConfig = .rounds(targetRounds: target)
        } else {
            // MODO PUNTOS
            let win = Int(valorGanadoTF.text ?? "") ?? 0
            let lose = Int(valorPerdidaTF.text ?? "") ?? 0
            let target = Int(puntajeRequeridoTF.text ?? "") ?? 0
            gameModeConfig = .points(winValue: win, loseValue: lose, targetScore: target)
        }

        let gameVC = GameScreenViewController()
        gameVC.playerName = nombre
        gameVC.mode = gameModeConfig

        if let nav = navigationController {
            nav.pushViewController(gameVC, animated: true)
        } else {
            present(gameVC, animated: true)
        }
    }

    @IBAction func infoPressed(_ sender: UIButton) {
        let infoVC = InfoViewController()

        if let nav = navigationController {
            nav.pushViewController(infoVC, animated: true)
        } else {
            infoVC.modalPresentationStyle = .formSheet
            present(infoVC, animated: true)
        }
    }


    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if string.isEmpty { return true }  // borrar

        if textField == valorGanadoTF ||
            textField == valorPerdidaTF ||
            textField == puntajeRequeridoTF {

            let allowed = CharacterSet.decimalDigits
            return string.rangeOfCharacter(from: allowed.inverted) == nil
        }

        return true
    }

    @objc private func endEditingNow() {
        view.endEditing(true)
    }
}
