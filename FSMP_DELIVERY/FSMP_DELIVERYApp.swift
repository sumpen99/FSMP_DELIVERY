//
//  FSMP_DELIVERYApp.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//
import SwiftUI

@main
struct FSMP_DELIVERYApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var phase
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var firebaseAuth = FirebaseAuth()
    @StateObject var firestoreViewModel = FirestoreViewModel()
    @StateObject var locationManager = LocationManager()
  
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
            .environmentObject(firebaseAuth)
            .environmentObject(firestoreViewModel)
            .environmentObject(locationViewModel)
            .environmentObject(locationManager)
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
}
