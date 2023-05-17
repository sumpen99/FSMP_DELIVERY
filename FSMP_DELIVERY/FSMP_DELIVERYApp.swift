//
//  FSMP_DELIVERYApp.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//
import SwiftUI
import FirebaseCore

/*class AppDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
}*/


@main
struct FSMP_DELIVERYApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var phase
    @StateObject var firebaseAuth = FirebaseAuth()
    @StateObject var firestoreViewModel = FirestoreViewModel()
  
    init(){
        FirebaseApp.configure()
    }
    
   
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
            .environmentObject(firebaseAuth)
            .environmentObject(firestoreViewModel)
          }
        }
        /*.onChange(of: phase) { newPhase in
            switch newPhase {
                case .active:
                    print(phase)
                case .inactive:
                    print(phase)
                case .background:
                    print(phase)
                @unknown default:
                    print("Unknown Future Options")
            }
        }*/
    }
    
}
