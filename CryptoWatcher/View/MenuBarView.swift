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
                    .fontWeight(.bold)
                Text(viewModel.value)
                    .foregroundColor(viewModel.color)
            }
            .font(.caption)
        }
        .onChange(of: viewModel.selectedCoin, perform: { newValue in
            viewModel.updateView()
        })
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
