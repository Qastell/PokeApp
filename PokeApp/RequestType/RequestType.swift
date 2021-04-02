//
//  RequestType.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//


enum RequestType {
    case pokemon(id: Int)
    
    var path: String {
        switch self {
        case .pokemon(let id):
            return "pokemon/\(id)"
        }
    }
}
