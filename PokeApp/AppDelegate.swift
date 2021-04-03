//
//  AppDelegate.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 01.04.2021.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private let localNotificationsService = LocalNotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        localNotificationsService.notificationRequest()
        PokeBGAppRefreshTaskService.shared.registerBGTasks()
        PokeBGProcessingTaskService.shared.registerBGTasks()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PokeController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

