//
//  SplashViewController.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import UIKit

final class SplashViewController: UIViewController {

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logoApp")
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let appNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Finance App"
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 30)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    navigateToLogin()
  }

  private func setupUI() {
    view.backgroundColor = .systemBlue
    navigationController?.setNavigationBarHidden(true, animated: false)

    view.addSubview(logoImageView)
    view.addSubview(appNameLabel)

    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
      logoImageView.widthAnchor.constraint(equalToConstant: 120),
      logoImageView.heightAnchor.constraint(equalToConstant: 120),

      appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
      appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  private func navigateToLogin() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
      let loginVC = LoginViewController()
      self?.navigationController?.setViewControllers([loginVC], animated: true)
    }
  }
}

