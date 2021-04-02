//
//  AppStatesObserver.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

protocol AppStatesObserverDelegate: class {
    func didEnterBackground()
    func willEnterForeground()
}

extension AppStatesObserverDelegate {
    func didEnterBackground() {}
    func willEnterForeground() {}
}

class AppStatesObserver {
    
    weak var delegate: AppStatesObserverDelegate?
    
    init() {
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc private func didEnterBackground() {
        delegate?.didEnterBackground()
    }
    
    @objc private func willEnterForeground() {
        delegate?.willEnterForeground()
    }
}
