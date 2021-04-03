//
//  PokeBGProcessingTaskService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 03.04.2021.
//

import UIKit
import BackgroundTasks

class PokeBGProcessingTaskService {
    static let shared = PokeBGProcessingTaskService()
    private init() {}
    
    private let appStatesObserver = AppStatesObserver()
    
    func registerBGTasks() {
        appStatesObserver.delegate = self
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Identifiers.processingFetchPokemon, using: nil) { [weak self] task in
            guard let task = task as? BGProcessingTask else { return }
            self?.handleAppRefreshTask(task: task)
        }
    }
    
    /**
     force the command to work
     e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mrq.processingFetchPokemon"]
     */
    private func handleAppRefreshTask(task: BGProcessingTask) {
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
        let pokemonFetchTask = BGProcessingTaskRequest(identifier: Identifiers.processingFetchPokemon)
        pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        pokemonFetchTask.requiresExternalPower = false
        pokemonFetchTask.requiresNetworkConnectivity = true
        
        do {
            try BGTaskScheduler.shared.submit(pokemonFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}

extension PokeBGProcessingTaskService: AppStatesObserverDelegate {
    func didEnterBackground() {
        scheduleBackgroundPokemonFetch()
    }
}

private extension PokeBGProcessingTaskService {
    struct Identifiers {
        static let processingFetchPokemon = "com.mrq.processingFetchPokemon"
    }
}
