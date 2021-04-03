//
//  PokeBGAppRefreshTaskService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 03.04.2021.
//

import UIKit
import BackgroundTasks

class PokeBGAppRefreshTaskService {
    static let shared = PokeBGAppRefreshTaskService()
    private init() {}
    
    private let appStatesObserver = AppStatesObserver()
    
    func registerBGTasks() {
        appStatesObserver.delegate = self
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Identifiers.fetchPokemon, using: nil) { [weak self] task in
            guard let task = task as? BGAppRefreshTask else { return }
            self?.handleAppRefreshTask(task: task)
        }
    }
    
    /**
     force the command to work
     e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mrq.fetchPokemon"]
     */
    private func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            URLSession.shared.invalidateAndCancel()
        }
        
        let randomNumber = Int.random(in: 0..<151)
        PokeService.shared.pokemon(id: randomNumber) { pokemon in
            NotificationCenter.default.post(name: .newPokemonFetched,
                                            object: self,
                                            userInfo: ["pokemon": pokemon])
            task.setTaskCompleted(success: true)
        }
        
        /// For repeating
        scheduleBackgroundPokemonFetch()
    }
    
    func scheduleBackgroundPokemonFetch() {
        let pokemonFetchTask = BGAppRefreshTaskRequest(identifier: Identifiers.fetchPokemon)
        pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(pokemonFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}

extension PokeBGAppRefreshTaskService: AppStatesObserverDelegate {
    func didEnterBackground() {
        scheduleBackgroundPokemonFetch()
    }
    
    func willEnterForeground() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}

private extension PokeBGAppRefreshTaskService {
    struct Identifiers {
        static let fetchPokemon = "com.mrq.fetchPokemon"
    }
}
