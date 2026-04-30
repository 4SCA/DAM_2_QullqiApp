//
//  Transaction.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import Foundation

enum TransactionType: String {
    case ingreso
    case egreso
}

struct Transaction {
    let id: String
    let userId: String

    let tipo: TransactionType
    let monto: Double
    let categoria: String

    let fecha: Date
}
