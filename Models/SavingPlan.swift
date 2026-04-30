//
//  SavingPlan.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import Foundation

enum TipoTransaction: String {
    case ingreso
    case egreso
}

struct Transaccion {
    let id: String
    let userId: String

    let tipo: TipoTransaction
    let monto: Double
    let categoria: String

    let fecha: Date
}
