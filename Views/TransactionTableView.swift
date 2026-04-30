//
//  TransactionTableView.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import UIKit

final class HomeViewController: UIViewController {

  // MARK: - Propiedades

  var usuario: User?

  private let scrollView = UIScrollView()
  private let contentView = UIView()

  private let welcomeLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let tipoLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let infoLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let logoutButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("CERRAR SESIÓN", for: .normal)
    btn.backgroundColor = .systemRed
    btn.setTitleColor(.white, for: .normal)
    btn.layer.cornerRadius = 10
    btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
    setupData()
  }

  // MARK: - UI

  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = "Inicio"

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    contentView.addSubview(welcomeLabel)
    contentView.addSubview(tipoLabel)
    contentView.addSubview(infoLabel)
    contentView.addSubview(logoutButton)

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

      welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
      welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      tipoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
      tipoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      tipoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      infoLabel.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 30),
      infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      logoutButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
      logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      logoutButton.heightAnchor.constraint(equalToConstant: 50),
      logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
    ])
  }

  // MARK: - Actions

  private func setupActions() {
    logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
  }

  // MARK: - Data

  private func setupData() {
    guard let usuario = usuario else { return }

    welcomeLabel.text = "Hola, \(usuario.nombre)"

    switch usuario.tipo {
    case .alumno:
      tipoLabel.text = "Alumno"

      if let alumno = usuario.alumno {
        infoLabel.text = "Meta de ahorro mensual:\nS/ \(alumno.metaAhorro)"
      }

    case .trabajador:
      tipoLabel.text = "Trabajador"

      if let trabajador = usuario.trabajador {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        infoLabel.text = """
        Sueldo: S/ \(trabajador.sueldo)
        Plan: \(trabajador.plan)
        Dia de pago: \(trabajador.diaPago)        
        """
      }
    }
  }

  // MARK: - Logout

  @objc private func logoutTapped() {
    navigationController?.setViewControllers([LoginViewController()], animated: true)
  }
}

