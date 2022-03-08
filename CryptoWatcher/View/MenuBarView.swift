//
//  MenuBarView.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 26/02/22.
//

import SwiftUI

struct MenuBarView: View {
    
    @ObservedObject var viewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .trailing, spacing: -2) {
                Text(viewModel.name)
                Text(viewModel.value)
            }
            .font(.caption)
        }
        .onAppear {
            viewModel.subToService()
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(viewModel: .init(name: "Bitcoin", value: "40,000", color: .green))
    }
}
