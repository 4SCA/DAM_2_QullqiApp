import Foundation

enum UserType {
    case alumno
    case trabajador
}

struct Alumno {
    var metaAhorro: Double
}

struct Trabajador {
    var sueldo: Double
    var diaPago: Int
    var plan: String
}
    
struct User {
    var nombre: String
    var apellido: String
    var email: String
    var password: String
    var tipo: UserType
    var alumno: Alumno?
    var trabajador: Trabajador?
}
