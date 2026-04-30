import Foundation

final class TransactionRepository {

  static let shared = TransactionRepository()
  private init() {}

  private var transactions: [Transaction] = []

  func add(_ transaction: Transaction) {
    transactions.append(transaction)
  }

  func getAll() -> [Transaction] {
    return transactions
  }

  func getThisMonth() -> [Transaction] {
    let calendar = Calendar.current
    return transactions.filter {
      calendar.isDate($0.fecha, equalTo: Date(), toGranularity: .month)
    }
  }

  func getSaldo() -> Double {
    var total: Double = 0

    for t in transactions {
      if t.tipo == .ingreso {
        total += t.monto
      } else {
        total -= t.monto
      }
    }

    return total
  }
}
