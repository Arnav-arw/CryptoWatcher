//
//  CryptoWatcherApp.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 24/02/22.
//

import SwiftUI

@main
struct CryptoWatcherApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView().frame(width: 0, height: 0) 
        }
    }
}
