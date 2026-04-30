import UIKit

final class DatosViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func setupUI() {
        title = "Estadísticas"
        view.backgroundColor = .systemGray6
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func updateData() {
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let repo = TransactionRepository.shared
        let saldo = repo.getSaldo()
        let ingresos = repo.getAll().filter { $0.tipo == .ingreso }.reduce(0) { $0 + $1.monto }
        let gastos = repo.getAll().filter { $0.tipo == .egreso }.reduce(0) { $0 + $1.monto }
        
        // Tarjeta de Balance Total
        let balanceCard = createStatCard(
            title: "Balance Total",
            value: "S/ \(String(format: "%.2f", saldo))",
            icon: "wallet.pass.fill",
            iconColor: .systemPurple,
            valueColor: saldo >= 0 ? .label : .systemRed
        )
        
        // Fila de Ingresos y Gastos
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 15
        rowStack.distribution = .fillEqually
        
        let ingresoCard = createStatCard(
            title: "Ingresos",
            value: "S/ \(ingresos)",
            icon: "arrow.down.circle.fill",
            iconColor: .systemGreen
        )
        
        let gastoCard = createStatCard(
            title: "Gastos",
            value: "S/ \(gastos)",
            icon: "arrow.up.circle.fill",
            iconColor: .systemRed
        )
        
        rowStack.addArrangedSubview(ingresoCard)
        rowStack.addArrangedSubview(gastoCard)
        
        // Tarjeta de Actividad
        let countCard = createStatCard(
            title: "Movimientos Totales",
            value: "\(repo.getAll().count) operaciones",
            icon: "chart.bar.doc.horizontal.fill",
            iconColor: .systemBlue
        )
        
        contentView.addArrangedSubview(balanceCard)
        contentView.addArrangedSubview(rowStack)
        contentView.addArrangedSubview(countCard)
    }
    
    private func createStatCard(title: String, value: String, icon: String, iconColor: UIColor, valueColor: UIColor = .label) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.05
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        
        let iconImg = UIImageView(image: UIImage(systemName: icon))
        iconImg.tintColor = iconColor
        iconImg.contentMode = .scaleAspectFit
        iconImg.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = valueColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconImg)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            iconImg.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconImg.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconImg.widthAnchor.constraint(equalToConstant: 30),
            iconImg.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: iconImg.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
}
