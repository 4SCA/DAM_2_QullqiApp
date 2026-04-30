//
//  MonthlyFinance.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import Foundation

final class UserRepository {

    // MARK: - Singleton
    static let shared = UserRepository()
    private init() {}

    // MARK: - Storage (temporal en memoria)
    private var usuarios: [User] = []

    // MARK: - CREATE

    func guardar(_ usuario: User) {
        usuarios.append(usuario)
    }

    // MARK: - READ

    func obtenerTodos() -> [User] {
        return usuarios
    }

    func obtenerPorEmail(_ email: String) -> User? {
        return usuarios.first {
            $0.email.lowercased() == email.lowercased()
        }
    }

    // MARK: - LOGIN

    func login(email: String, password: String) -> User? {
        return usuarios.first {
            $0.email.lowercased() == email.lowercased() &&
            $0.password == password
        }
    }

    // MARK: - UPDATE

    func actualizar(_ usuarioActualizado: User) {
        if let index = usuarios.firstIndex(where: {
            $0.email.lowercased() == usuarioActualizado.email.lowercased()
        }) {
            usuarios[index] = usuarioActualizado
        }
    }

    // MARK: - DELETE

    func eliminarPorEmail(_ email: String) {
        usuarios.removeAll {
            $0.email.lowercased() == email.lowercased()
        }
    }

    func eliminarTodos() {
        usuarios.removeAll()
    }

    // MARK: - HELPERS DE DATOS (no validación de formato)

    func existeEmail(_ email: String) -> Bool {
        return usuarios.contains {
            $0.email.lowercased() == email.lowercased()
        }
    }

    func cantidadUsuarios() -> Int {
        return usuarios.count
    }
}

