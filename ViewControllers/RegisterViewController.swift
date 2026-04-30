
import UIKit

final class RegisterViewController: UIViewController, UITextFieldDelegate {

  // MARK: - UI

  private let headerLabel: UILabel = {
    let label = UILabel()
    label.text = "QullqiApp"
    label.font = .boldSystemFont(ofSize: 32)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let nombreField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Nombre"
    tf.borderStyle = .roundedRect
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
    
  private let apellidoField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Apellido"
    tf.borderStyle = .roundedRect
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
    
  private let emailField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Correo"
    tf.borderStyle = .roundedRect
    tf.keyboardType = .emailAddress
    tf.autocapitalizationType = .none
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let passwordField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Contraseña"
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let tipoSegment = UISegmentedControl(items: ["Alumno", "Trabajador"])

  private let metaField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Meta de ahorro"
    tf.borderStyle = .roundedRect
    tf.keyboardType = .decimalPad
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
    
  private let sueldoField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Sueldo"
    tf.borderStyle = .roundedRect
    tf.keyboardType = .numberPad
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let planField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Seleccionar plan"
    tf.borderStyle = .roundedRect
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let diaField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Día de pago (1 - 31)"
    tf.borderStyle = .roundedRect
    tf.keyboardType = .numberPad
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
    
  private let registerButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("REGISTRAR", for: .normal)
    btn.backgroundColor = .systemBlue
    btn.setTitleColor(.white, for: .normal)
    btn.layer.cornerRadius = 12
    btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  // MARK: - Picker

  private let planPicker = UIPickerView()

  private let planes = [
    "Básico (10% - 15%)",
    "Intermedio (20% - 25%)",
    "Estricto (30% - 35%)"
  ]

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
    actualizarCampos()
    setupKeyboardDismiss()

    // 👇 IMPORTANTE
    sueldoField.delegate = self

    navigationController?.setNavigationBarHidden(false, animated: true)

    navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(volverInicio)
    )
  }

  // MARK: - UI Setup

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Registro"

    tipoSegment.selectedSegmentIndex = 0

    planPicker.delegate = self
    planPicker.dataSource = self
    planField.inputView = planPicker

    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let done = UIBarButtonItem(title: "Listo", style: .prominent, target: self, action: #selector(donePicker))
    toolbar.setItems([done], animated: true)
    planField.inputAccessoryView = toolbar

    let stack = UIStackView(arrangedSubviews: [
      headerLabel,
      nombreField,
      apellidoField,
      emailField,
      passwordField,
      tipoSegment,
      metaField,
      sueldoField,
      planField,
      diaField,
      registerButton
    ])

    stack.axis = .vertical
    stack.spacing = 16
    stack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      registerButton.heightAnchor.constraint(equalToConstant: 55)
    ])
  }

  // MARK: - Actions

  private func setupActions() {
    tipoSegment.addTarget(self, action: #selector(cambiarTipo), for: .valueChanged)
    registerButton.addTarget(self, action: #selector(registrarTapped), for: .touchUpInside)
  }

  private func setupKeyboardDismiss() {
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
    
  @objc private func volverInicio() {
    navigationController?.popViewController(animated: true)
  }
    
  @objc private func cambiarTipo() {
    actualizarCampos()
  }

  private func actualizarCampos() {
    let esAlumno = tipoSegment.selectedSegmentIndex == 0
    metaField.isHidden = !esAlumno
    sueldoField.isHidden = esAlumno
    planField.isHidden = esAlumno
    diaField.isHidden = esAlumno
  }

  @objc private func donePicker() {
    view.endEditing(true)
  }

  // MARK: - Registro

  @objc private func registrarTapped() {

    let nombre = nombreField.text ?? ""
    let email = emailField.text ?? ""
    let password = passwordField.text ?? ""

    do {
      try Validators.validateLogin(email: email, password: password)

      if nombre.trimmingCharacters(in: .whitespaces).isEmpty {
        showAlert("Error", "Nombre obligatorio")
        return
      }

      if UsuarioRepository.shared.existeEmail(email) {
        showAlert("Error", "Correo ya registrado")
        return
      }
        
      let apellido = apellidoField.text ?? ""

      if apellido.trimmingCharacters(in: .whitespaces).isEmpty {
        showAlert("Error", "Apellido obligatorio")
        return
      }
        
      let usuario: User

      if tipoSegment.selectedSegmentIndex == 0 {
        let meta = Double(metaField.text ?? "") ?? 0
        usuario = User(
            nombre: nombre,
            apellido: apellido,
            email: email,
            password: password,
            tipo: .alumno,
            alumno: Alumno(metaAhorro: meta),
            trabajador: nil
        )
      } else {
        let sueldo = Double(sueldoField.text ?? "") ?? 0
        let plan = planField.text ?? ""
        let dia = Int(diaField.text ?? "") ?? 0

        if dia < 1 || dia > 31 {
            showAlert("Error", "El día debe estar entre 1 y 31")
            return
        }

        usuario = User(
            nombre: nombre,
            apellido: apellido,
            email: email,
            password: password,
            tipo: .trabajador,
            alumno: nil,
            trabajador: Trabajador(
                sueldo: sueldo,
                diaPago: dia,
                plan: plan
            )
        )
      }

      UsuarioRepository.shared.guardar(usuario)

      let mainVC = MainViewController()
      mainVC.usuario = usuario

      let alert = UIAlertController(title: "Éxito", message: "Usuario registrado", preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
          self.navigationController?.setViewControllers([mainVC], animated: true)
      }))

      present(alert, animated: true)

    } catch let error as ValidationError {
      showAlert("Error", error.rawValue)
    } catch {
      showAlert("Error", "Error inesperado")
    }
  }

  private func showAlert(_ title: String, _ message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  // MARK: - UITextFieldDelegate

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if textField == sueldoField {
          let allowedCharacters = CharacterSet.decimalDigits
          let characterSet = CharacterSet(charactersIn: string)
          return allowedCharacters.isSuperset(of: characterSet)
      }
      
      return true
  }
}

// MARK: - Picker

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return planes.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return planes[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    planField.text = planes[row]
  }
}


