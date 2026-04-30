//
//  Validators.swift
//  QullqiApp
//
//  Created by DESIGN on 23/04/26.
//
import Foundation

enum ValidationError: String, Error {
    case emailVacio = "El correo no puede estar vacío"
    case emailInvalido = "El correo no es válido"
    case passwordInvalido = "La contraseña debe tener mayúscula, minúscula y número"
}

struct Validators {

    static func validateLogin(email: String, password: String) throws {

        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            throw ValidationError.emailVacio
        }

        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let valido = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)

        if !valido {
            throw ValidationError.emailInvalido
        }

        let tieneMayuscula = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let tieneMinuscula = password.range(of: "[a-z]", options: .regularExpression) != nil
        let tieneNumero = password.range(of: "[0-9]", options: .regularExpression) != nil

        if !(password.count >= 6 && tieneMayuscula && tieneMinuscula && tieneNumero) {
            throw ValidationError.passwordInvalido
        }
    }
}

