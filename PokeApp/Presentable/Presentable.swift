//
//  Presentable.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController {
        return self
    }
}
