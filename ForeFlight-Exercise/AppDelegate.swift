//
//  AppDelegate.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/19/23.
//

import BackgroundTasks
import OSLog
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let logger = Logger()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.backgroundTaskIdentifier, using: nil) { backgroundTask in
            self.logger.info("Attempting to perform a background refresh for: \(Constants.backgroundTaskIdentifier)!")
            backgroundTask.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.logger.info("Application did enter background!")
        self.scheduleAppRefresh()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called 
        // shortly after application:didFinishLaunchingWithOptions. Use this method to release any resources
        // that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Private Methods
    func scheduleAppRefresh() {
        let settings = CacheClient.shared.restoreSettingsFromCache()
        
        var timeInterval: TimeInterval
        let minuteInSeconds: Double = 60.0
        
        switch settings.fetchInterval {
        case .oneMinute:
            timeInterval = 1.0 * minuteInSeconds
        case .fiveMinutes:
            timeInterval = 5.0 * minuteInSeconds
        case .fifteenMinutes:
            timeInterval = 15.0 * minuteInSeconds
        }
        
        let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: timeInterval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            logger.error("Could not schedule background refresh task: \(error.localizedDescription)")
        }
    }
}
