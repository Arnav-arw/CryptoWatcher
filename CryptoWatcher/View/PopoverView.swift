//
//  PopoverView.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 28/02/22.
//

import SwiftUI

struct PopoverView: View {
    
    @ObservedObject var viewModel: popoverViewModel
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                Text(viewModel.subtitle)
                    .font(.title.bold())
            }
            Divider()
            
            Picker("Select Coin", selection: $viewModel.selectedCoin) {
                ForEach(viewModel.coinTypes) { type in
                    HStack {
                        Text(type.desc)
                            .font(.headline)
                        Spacer()
                        Text(viewModel.valueText(for: type))
                            .frame(alignment: .trailing)
                        Link(destination: type.url) {
                            Image(systemName: "safari")
                        }
                    }
                    .tag(type)
                }
            }
            .pickerStyle(.radioGroup)
            .labelsHidden()
            Button("Quit") {
                NSApp.terminate(self)
            }
        }
        .onChange(of: viewModel.selectedCoin, perform: { newValue in
            viewModel.updateView()
        })
        .onAppear {
            viewModel.subToService()
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(viewModel: .init(title: "Bitcoin", subtitle: "40,000"))
    }
}
