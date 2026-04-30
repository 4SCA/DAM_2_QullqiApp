import UIKit

final class MovimientoViewController: UIViewController {

  var tipoMovimiento: TransactionType = .egreso

  private let tipoSegmented = UISegmentedControl(items: ["Ingreso", "Egreso"])
  private let montoTextField = UITextField()
  private let categoriaTextField = UITextField()
  private let descripcionTextField = UITextField()
  private let datePicker = UIDatePicker()
  private let guardarButton = UIButton(type: .system)

  private let categoriaPicker = UIPickerView()
  private var categorias: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupData()
    addToolbar()
  }

  private func setupUI() {
    view.backgroundColor = .systemGray6
    title = "Registrar Movimiento"

    tipoSegmented.selectedSegmentIndex = tipoMovimiento == .ingreso ? 0 : 1
    tipoSegmented.addTarget(self, action: #selector(tipoChanged), for: .valueChanged)

    montoTextField.placeholder = "Monto"
    montoTextField.keyboardType = .decimalPad
    montoTextField.borderStyle = .roundedRect
    montoTextField.delegate = self

    categoriaTextField.placeholder = "Categoría"
    categoriaTextField.borderStyle = .roundedRect

    categoriaPicker.delegate = self
    categoriaPicker.dataSource = self
    categoriaTextField.inputView = categoriaPicker

    descripcionTextField.placeholder = "Descripción"
    descripcionTextField.borderStyle = .roundedRect

    datePicker.datePickerMode = .date

    guardarButton.setTitle("Guardar", for: .normal)
    guardarButton.backgroundColor = .systemPurple
    guardarButton.tintColor = .white
    guardarButton.layer.cornerRadius = 10
    guardarButton.addTarget(self, action: #selector(guardarMovimiento), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [
      tipoSegmented,
      montoTextField,
      categoriaTextField,
      datePicker,
      descripcionTextField,
      guardarButton
    ])

    stack.axis = .vertical
    stack.spacing = 16
    stack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      guardarButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func setupData() {
    actualizarCategorias()
  }

  private func actualizarCategorias() {
    if tipoMovimiento == .ingreso {
      categorias = ["Sueldo", "Ingreso extra", "Otro"]
    } else {
      categorias = ["Alimento", "Transporte", "Entretenimiento", "Otro"]
    }

    categoriaPicker.reloadAllComponents()
    categoriaPicker.selectRow(0, inComponent: 0, animated: true)
    categoriaTextField.text = categorias.first
  }

  @objc private func tipoChanged() {
    tipoMovimiento = tipoSegmented.selectedSegmentIndex == 0 ? .ingreso : .egreso
    actualizarCategorias()
  }

  @objc private func guardarMovimiento() {

    guard let montoText = montoTextField.text,
          let monto = Double(montoText),
          monto > 0,
          let categoria = categoriaTextField.text,
          !categoria.isEmpty else {
      mostrarAlerta("Ingresa un monto válido mayor a 0")
      return
    }

    let nueva = Transaction(
      id: UUID().uuidString,
      userId: "1",
      tipo: tipoMovimiento,
      monto: monto,
      categoria: categoria,
      fecha: datePicker.date
    )

    TransactionRepository.shared.add(nueva)

    // 🔥 NOTIFICACIÓN PARA ACTUALIZAR MAIN
    NotificationCenter.default.post(name: NSNotification.Name("nuevoMovimiento"), object: nil)

    // Limpiar campos (opcional)
    montoTextField.text = ""
    descripcionTextField.text = ""

    mostrarAlertaExito()
  }

  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()

    let done: UIBarButtonItem
    if #available(iOS 26.0, *) {
      done = UIBarButtonItem(title: "Listo", style: .prominent, target: self, action: #selector(dismissPicker))
    } else {
      done = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissPicker))
    }

    toolbar.setItems([done], animated: false)
    categoriaTextField.inputAccessoryView = toolbar
  }

  @objc private func dismissPicker() {
    view.endEditing(true)
  }

  private func mostrarAlerta(_ msg: String) {
    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  private func mostrarAlertaExito() {
    let alert = UIAlertController(title: "Éxito", message: "Guardado", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      self.navigationController?.popViewController(animated: true)
    })
    present(alert, animated: true)
  }
}

// MARK: - Picker

extension MovimientoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    categorias.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    categorias[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    categoriaTextField.text = categorias[row]
  }
}

// MARK: - TextField

extension MovimientoViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

    if textField == montoTextField {
      let allowed = "0123456789."
      if string.rangeOfCharacter(from: CharacterSet(charactersIn: allowed).inverted) != nil {
        return false
      }

      if let text = textField.text, text.contains("."), string == "." {
        return false
      }
    }

    return true
  }
}
