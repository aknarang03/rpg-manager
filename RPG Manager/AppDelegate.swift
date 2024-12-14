//
//  AppDelegate.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
//    // MARK: UISceneSession Lifecycle

}

@main
struct RPGManagerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // for firebase
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isInStory && appState.isLoggedIn {
                StoryView()
                    .environmentObject(appState)
            }
            else if appState.isLoggedIn {
                HomeView()
                    .environmentObject(appState)
            } else {
                LoginView()
                    .environmentObject(appState)
            }
        }
    }
    
}

