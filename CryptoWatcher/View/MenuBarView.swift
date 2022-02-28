//
//  MenuBarView.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 26/02/22.
//

import SwiftUI

struct MenuBarView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "bitcoinsign.circle")
            
            VStack(alignment: .trailing, spacing: -2) {
                Text("Bitcoin")
                Text("$35,000")
            }
            .font(.caption)
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
