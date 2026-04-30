import UIKit
import PDFKit

final class HistorialViewController: UIViewController {
    
    private let tableView = UITableView()
    private var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        title = "Historial"
        view.backgroundColor = .systemGray6
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "doc.text.fill"),
            style: .plain,
            target: self,
            action: #selector(exportPDF)
        )
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
    }
    
    private func loadData() {
        self.transactions = TransactionRepository.shared.getAll().reversed()
        tableView.reloadData()
    }

    @objc private func exportPDF() {
        let pageWidth: CGFloat = 595.2
        let pageHeight: CGFloat = 841.8
        let margin: CGFloat = 50
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { (context) in
            context.beginPage()
            
            if let logo = UIImage(named: "AppIcon") {
                logo.draw(in: CGRect(x: margin, y: 40, width: 50, height: 50))
            }
            
            let titleAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.systemPurple
            ]
            "REPORTE DE MOVIMIENTOS".draw(at: CGPoint(x: 120, y: 50), withAttributes: titleAttr)
            
            let dateAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]
            "QullqiApp - \(Date().formatted(date: .long, time: .shortened))".draw(at: CGPoint(x: 120, y: 75), withAttributes: dateAttr)
            
            var yPos: CGFloat = 130
            let columnWidth = (pageWidth - (margin * 2)) / 4
            
            context.cgContext.setFillColor(UIColor.systemGray6.cgColor)
            context.cgContext.fill(CGRect(x: margin, y: yPos, width: pageWidth - (margin * 2), height: 30))
            
            let headers = ["Fecha", "Categoría", "Tipo", "Monto"]
            for (i, header) in headers.enumerated() {
                header.draw(in: CGRect(x: margin + (CGFloat(i) * columnWidth), y: yPos + 7, width: columnWidth, height: 20),
                            withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
            }
            
            yPos += 40
            for t in transactions {
                if yPos > pageHeight - 50 { context.beginPage(); yPos = margin }
                
                let rowAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11)]
                t.fecha.formatted(date: .numeric, time: .omitted).draw(in: CGRect(x: margin, y: yPos, width: columnWidth, height: 20), withAttributes: rowAttr)
                t.categoria.draw(in: CGRect(x: margin + columnWidth, y: yPos, width: columnWidth, height: 20), withAttributes: rowAttr)
                
                let color = t.tipo == .ingreso ? UIColor.systemGreen : UIColor.systemRed
                (t.tipo == .ingreso ? "Ingreso" : "Egreso").draw(in: CGRect(x: margin + (columnWidth * 2), y: yPos, width: columnWidth, height: 20),
                                                                withAttributes: [.font: UIFont.boldSystemFont(ofSize: 11), .foregroundColor: color])
                
                "S/ \(String(format: "%.2f", t.monto))".draw(in: CGRect(x: margin + (columnWidth * 3), y: yPos, width: columnWidth, height: 20), withAttributes: rowAttr)
                
                yPos += 25
            }
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Reporte_Qullqi.pdf")
        try? data.write(to: tempURL)
        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

extension HistorialViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

final class TransactionCell: UITableViewCell {
    
    private let containerView = UIView()
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        contentView.addSubview(containerView)
        
        iconContainer.layer.cornerRadius = 20
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel
        amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
        amountLabel.textAlignment = .right
        
        [iconContainer, iconImageView, categoryLabel, dateLabel, amountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            categoryLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with t: Transaction) {
        categoryLabel.text = t.categoria
        dateLabel.text = t.fecha.formatted(date: .abbreviated, time: .omitted)
        
        if t.tipo == .ingreso {
            amountLabel.text = "+ S/ \(String(format: "%.2f", t.monto))"
            amountLabel.textColor = .systemGreen
            iconContainer.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            iconImageView.image = UIImage(systemName: "arrow.down.left.circle.fill")
            iconImageView.tintColor = .systemGreen
        } else {
            amountLabel.text = "- S/ \(String(format: "%.2f", t.monto))"
            amountLabel.textColor = .systemRed
            iconContainer.backgroundColor = .systemRed.withAlphaComponent(0.1)
            iconImageView.image = UIImage(systemName: "arrow.up.right.circle.fill")
            iconImageView.tintColor = .systemRed
        }
    }
}
