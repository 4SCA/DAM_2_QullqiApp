//
//  LoginViewController.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import UIKit

final class LoginViewController: UIViewController {

  private let scrollView = UIScrollView()
  private let contentView = UIView()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logoApp")
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let emailLabel: UILabel = {
    let label = UILabel()
    label.text = "Correo"
    label.font = .boldSystemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "name@example.com"
    tf.borderStyle = .roundedRect
    tf.keyboardType = .emailAddress
    tf.autocapitalizationType = .none
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let passwordLabel: UILabel = {
    let label = UILabel()
    label.text = "Contraseña"
    label.font = .boldSystemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "********"
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let loginButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("INGRESAR", for: .normal)
    btn.backgroundColor = .systemBlue
    btn.setTitleColor(.white, for: .normal)
    btn.layer.cornerRadius = 10
    btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  private let registerButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("REGISTRAR", for: .normal)
    btn.backgroundColor = .systemGreen
    btn.setTitleColor(.white, for: .normal)
    btn.layer.cornerRadius = 10
    btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
    setupKeyboardDismiss()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Login"

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    contentView.addSubview(logoImageView)
    contentView.addSubview(emailLabel)
    contentView.addSubview(emailTextField)
    contentView.addSubview(passwordLabel)
    contentView.addSubview(passwordTextField)
    contentView.addSubview(loginButton)
    contentView.addSubview(registerButton)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
      logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 120),
      logoImageView.heightAnchor.constraint(equalToConstant: 120),

      emailLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
      emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

      emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
      emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      emailTextField.heightAnchor.constraint(equalToConstant: 50),

      passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
      passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
      passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      passwordTextField.heightAnchor.constraint(equalToConstant: 50),

      loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
      loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 52),

      registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
      registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      registerButton.heightAnchor.constraint(equalToConstant: 52),
      registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
    ])
  }

  private func setupActions() {
    loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
  }

  private func setupKeyboardDismiss() {
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }

  @objc private func loginTapped() {
    let email = emailTextField.text ?? ""
    let password = passwordTextField.text ?? ""

    do {
      try Validators.validateLogin(email: email, password: password)

      guard let usuario = UsuarioRepository.shared.login(email: email, password: password) else {
        showAlert("Error", "Credenciales incorrectas")
        return
      }

      let main = MainViewController()
      main.usuario = usuario
      navigationController?.pushViewController(main, animated: true)

    } catch let error as ValidationError {
      showAlert("Error", error.rawValue)
    } catch {
      showAlert("Error", "Error inesperado")
    }
  }

  @objc private func registerTapped() {
    navigationController?.pushViewController(RegisterViewController(), animated: true)
  }

  private func showAlert(_ title: String, _ message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

