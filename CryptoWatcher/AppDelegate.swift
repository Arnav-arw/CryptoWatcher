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
    
    var menuBarViewModel: CoinViewModel!
    var popoverViewModel: popoverViewModel!
    let coinCapAPI = CoinCapAPI()
    var statusItem: NSStatusItem!
    let popover = NSPopover()
    
    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpCoinCapAPI()
        setUpMenuBar()
        setUpPopover()
    }
    
    func setUpCoinCapAPI() {
        coinCapAPI.connect()
    }
}


extension AppDelegate {
    func setUpMenuBar() {
        menuBarViewModel = CoinViewModel(service: coinCapAPI)
        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        
        guard let contentView = self.contentView,
              let menuButton = statusItem.button
        else { return }
        
        let customView = NSHostingView(rootView: MenuBarView(viewModel: menuBarViewModel))
        customView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            customView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        menuButton.action = #selector(menuButtonClicked)
    }
    
    @objc func menuButtonClicked() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        guard let menuButton = statusItem.button
        else { return }
        
        popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
        popover.contentViewController?.view.window?.makeKey()
    }
}

extension AppDelegate {
    func setUpPopover() {
        popoverViewModel = .init(service: coinCapAPI)
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = .init(width: 240, height: 280)
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(
            rootView: PopoverView(viewModel: popoverViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        )
    }
}
