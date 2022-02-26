//
//  AppDelegate.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 26/02/22.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    
    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpMenuBar()
    }
}


extension AppDelegate {
    func setUpMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        
        guard let contentView = self.contentView,
              let menuButton = statusItem.button
        else { return }
        
        let customView = NSHostingView(rootView: MenuBarView())
        customView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            customView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
