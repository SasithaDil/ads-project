//
//  nibmApp.swift
//  nibm
//
//  Created by Sasitha Dilshan on 2022-03-23.
//

import SwiftUI
import Firebase

@main
struct nibmApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
