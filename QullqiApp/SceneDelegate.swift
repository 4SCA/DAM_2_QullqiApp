//
//  SceneDelegate.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }

    // Crear ventana principal
    let window = UIWindow(windowScene: windowScene)

    // Pantalla inicial (Splash)
    let splashVC = SplashViewController()

    // Navegación
    let navigationController = UINavigationController(rootViewController: splashVC)
    navigationController.navigationBar.prefersLargeTitles = false

    // Asignar root
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    self.window = window
  }
}

