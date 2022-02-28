//
//  PopoverView.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 28/02/22.
//

import SwiftUI

struct PopoverView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Bitcoin")
                .font(.largeTitle)
            Text("$35,000")
                .font(.title.bold())
            Divider()
            Button("Quit") {
                NSApp.terminate(self)
        }
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
