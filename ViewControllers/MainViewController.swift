import UIKit

final class MainViewController: UIViewController {

  var usuario: User?

  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let welcomeLabel = UILabel()
  private let tipoLabel = UILabel()
  private let statusImageView = UIImageView()
  private let statusLabel = UILabel()
  private let progressLabel = UILabel()
  private let progressView = UIProgressView(progressViewStyle: .default)
  private let saldoCard = UIView()
  private let movimientosCard = UIView()
  private let saldoValueLabel = UILabel()
  private let movimientosStack = UIStackView()

  private var saldoVisible = false
  private var movimientosVisibles = false
  private let floatingButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
    setupData()
    setupNavigationBar()

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(actualizarTodo),
                                           name: NSNotification.Name("nuevoMovimiento"),
                                           object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    actualizarTodo()
  }

  @objc private func actualizarTodo() {
    actualizarEstadoMeta()
    cargarMovimientos()
    if saldoVisible {
        saldoValueLabel.text = "S/ \(String(format: "%.2f", TransactionRepository.shared.getSaldo()))"
    }
  }

  private func setupNavigationBar() {
    let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(openMenu))
    let userButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(openUserMenu))
    navigationItem.leftBarButtonItem = menuButton
    navigationItem.rightBarButtonItem = userButton
  }

  @objc private func openMenu() {
    let alert = UIAlertController(title: "Menú", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Historial", style: .default) { _ in self.goToHistorial() })
    alert.addAction(UIAlertAction(title: "Datos", style: .default) { _ in self.goToDatos() })
    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
    present(alert, animated: true)
  }

  @objc private func openUserMenu() {
    let alert = UIAlertController(title: "Usuario", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive) { _ in self.logout() })
    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
    present(alert, animated: true)
  }

  private func goToHistorial() {
    navigationController?.pushViewController(HistorialViewController(), animated: true)
  }

  private func goToDatos() {
    navigationController?.pushViewController(DatosViewController(), animated: true)
  }

  private func logout() {
    navigationController?.setViewControllers([LoginViewController()], animated: true)
  }

  private func setupUI() {
    view.backgroundColor = .systemGray6
    title = "QullqiApp"

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    [welcomeLabel, tipoLabel, statusImageView, statusLabel, progressLabel, progressView, saldoCard, movimientosCard, movimientosStack].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }

    welcomeLabel.font = .boldSystemFont(ofSize: 22)
    welcomeLabel.textAlignment = .center
    tipoLabel.textAlignment = .center
    tipoLabel.textColor = .gray
    statusLabel.font = .boldSystemFont(ofSize: 18)
    statusLabel.textAlignment = .center
    progressLabel.font = .systemFont(ofSize: 14)
    progressLabel.textColor = .gray
    progressView.trackTintColor = .systemGray4
    progressView.progressTintColor = .systemPurple

    [saldoCard, movimientosCard].forEach {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 12
      $0.isUserInteractionEnabled = true
    }

    let saldoTitle = UILabel()
    saldoTitle.text = "Saldo"
    saldoTitle.translatesAutoresizingMaskIntoConstraints = false
    let eyeIcon = UIImageView(image: UIImage(systemName: "eye"))
    eyeIcon.translatesAutoresizingMaskIntoConstraints = false
    saldoValueLabel.text = "S/ ******"
    saldoValueLabel.translatesAutoresizingMaskIntoConstraints = false
    saldoCard.addSubview(saldoTitle)
    saldoCard.addSubview(eyeIcon)
    saldoCard.addSubview(saldoValueLabel)

    let movLabel = UILabel()
    movLabel.text = "Mostrar movimientos"
    movLabel.translatesAutoresizingMaskIntoConstraints = false
    let arrowIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
    arrowIcon.translatesAutoresizingMaskIntoConstraints = false
    movimientosCard.addSubview(movLabel)
    movimientosCard.addSubview(arrowIcon)

    movimientosStack.axis = .vertical
    movimientosStack.spacing = 8
    movimientosStack.alpha = 0
    movimientosStack.isHidden = true

    floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
    floatingButton.tintColor = .white
    floatingButton.backgroundColor = .systemPurple
    floatingButton.layer.cornerRadius = 28
    floatingButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(floatingButton)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

      welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      welcomeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      tipoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
      tipoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      statusImageView.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 20),
      statusImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      statusImageView.heightAnchor.constraint(equalToConstant: 60),
      statusImageView.widthAnchor.constraint(equalToConstant: 60),

      statusLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 10),
      statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      progressView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
      progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      progressView.heightAnchor.constraint(equalToConstant: 8),

      progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
      progressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      saldoCard.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 30),
      saldoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      saldoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      saldoCard.heightAnchor.constraint(equalToConstant: 60),

      saldoTitle.leadingAnchor.constraint(equalTo: saldoCard.leadingAnchor, constant: 16),
      saldoTitle.centerYAnchor.constraint(equalTo: saldoCard.centerYAnchor),
      eyeIcon.trailingAnchor.constraint(equalTo: saldoCard.trailingAnchor, constant: -16),
      eyeIcon.centerYAnchor.constraint(equalTo: saldoCard.centerYAnchor),
      saldoValueLabel.trailingAnchor.constraint(equalTo: eyeIcon.leadingAnchor, constant: -8),
      saldoValueLabel.centerYAnchor.constraint(equalTo: saldoCard.centerYAnchor),

      movimientosCard.topAnchor.constraint(equalTo: saldoCard.bottomAnchor, constant: 16),
      movimientosCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      movimientosCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      movimientosCard.heightAnchor.constraint(equalToConstant: 60),

      movLabel.leadingAnchor.constraint(equalTo: movimientosCard.leadingAnchor, constant: 16),
      movLabel.centerYAnchor.constraint(equalTo: movimientosCard.centerYAnchor),
      arrowIcon.trailingAnchor.constraint(equalTo: movimientosCard.trailingAnchor, constant: -16),
      arrowIcon.centerYAnchor.constraint(equalTo: movimientosCard.centerYAnchor),

      movimientosStack.topAnchor.constraint(equalTo: movimientosCard.bottomAnchor, constant: 10),
      movimientosStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      movimientosStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      movimientosStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),

      floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      floatingButton.widthAnchor.constraint(equalToConstant: 56),
      floatingButton.heightAnchor.constraint(equalToConstant: 56)
    ])
  }

  private func setupActions() {
    floatingButton.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    saldoCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSaldo)))
    movimientosCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMovimientos)))
  }

  @objc private func fabTapped() {
    navigationController?.pushViewController(MovimientoViewController(), animated: true)
  }

  @objc private func toggleSaldo() {
    saldoVisible.toggle()
    saldoValueLabel.text = saldoVisible ? "S/ \(String(format: "%.2f", TransactionRepository.shared.getSaldo()))" : "S/ ******"
  }

  @objc private func toggleMovimientos() {
    movimientosVisibles.toggle()
    let arrow = movimientosCard.subviews.compactMap { $0 as? UIImageView }.first
    
    UIView.animate(withDuration: 0.3) {
      self.movimientosStack.alpha = self.movimientosVisibles ? 1 : 0
      self.movimientosStack.isHidden = !self.movimientosVisibles
      arrow?.transform = self.movimientosVisibles ? CGAffineTransform(rotationAngle: .pi) : .identity
    }
  }

  private func setupData() {
    guard let usuario = usuario else { return }
    welcomeLabel.text = "Hola, \(usuario.nombre)"
    tipoLabel.text = usuario.tipo == .alumno ? "Alumno" : "Trabajador"
    actualizarEstadoMeta()
    cargarMovimientos()
  }

  private func actualizarEstadoMeta() {
    let saldo = TransactionRepository.shared.getSaldo()
    if let usuario = usuario, usuario.tipo == .alumno, let alumno = usuario.alumno {
        let meta = alumno.metaAhorro
        let progreso = Float(saldo / meta)
        progressView.setProgress(progreso, animated: true)
        progressLabel.text = "S/ \(saldo) de S/ \(meta)"
        statusLabel.text = saldo >= meta ? "¡Meta Alcanzada! 🎉" : "Sigue ahorrando 💪"
        statusImageView.image = UIImage(systemName: saldo >= meta ? "star.fill" : "cart")
        progressView.isHidden = false
    } else {
        statusLabel.text = "Tu balance actual"
        progressLabel.text = "S/ \(saldo)"
        progressView.isHidden = true
    }
  }

  private func cargarMovimientos() {
    movimientosStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    let movimientos = TransactionRepository.shared.getAll().suffix(5).reversed()
    
    for mov in movimientos {
      let row = UIView()
      row.backgroundColor = .white
      row.layer.cornerRadius = 10
      row.translatesAutoresizingMaskIntoConstraints = false
      
      let iconView = UIImageView(image: UIImage(systemName: mov.tipo == .ingreso ? "arrow.down.left.circle.fill" : "arrow.up.right.circle.fill"))
      iconView.tintColor = mov.tipo == .ingreso ? .systemGreen : .systemRed
      iconView.translatesAutoresizingMaskIntoConstraints = false
      
      let catLabel = UILabel()
      catLabel.text = mov.categoria
      catLabel.font = .systemFont(ofSize: 14, weight: .medium)
      catLabel.translatesAutoresizingMaskIntoConstraints = false
      
      let amtLabel = UILabel()
      amtLabel.text = "\(mov.tipo == .ingreso ? "+" : "-") S/ \(String(format: "%.2f", mov.monto))"
      amtLabel.font = .systemFont(ofSize: 14, weight: .bold)
      amtLabel.textColor = mov.tipo == .ingreso ? .systemGreen : .systemRed
      amtLabel.translatesAutoresizingMaskIntoConstraints = false
      
      row.addSubview(iconView)
      row.addSubview(catLabel)
      row.addSubview(amtLabel)
      
      NSLayoutConstraint.activate([
        row.heightAnchor.constraint(equalToConstant: 45),
        iconView.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 10),
        iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        iconView.widthAnchor.constraint(equalToConstant: 24),
        iconView.heightAnchor.constraint(equalToConstant: 24),
        catLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
        catLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        amtLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -10),
        amtLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor)
      ])
      movimientosStack.addArrangedSubview(row)
    }
  }
}
