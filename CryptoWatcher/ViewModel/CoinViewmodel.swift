//
//  CoinViewmodel.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 08/03/22.
//

import Foundation
import SwiftUI
import Combine

class CoinViewModel: ObservableObject {
    @Published private(set) var name: String
    @Published private(set) var value: String
    @Published private(set) var color: Color
    @AppStorage("SelectedCoinType") private(set) var selectedCoin = CoinType.bitcoin
    
    private let service: CoinCapAPI
    private var subscriptions = Set<AnyCancellable>()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    init(name: String = "", value: String = "", color: Color = .green, service: CoinCapAPI = .init()) {
        self.name = name
        self.value = value
        self.color = color
        self.service = service
    }
    
    func subToService() {
        service.coinSubject
            .combineLatest(service.connectionStateSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.updateView() }
            .store(in: &subscriptions)
    }
    
    func updateView() {
        let coin = self.service.coinDictionary[selectedCoin.rawValue]
        self.name = coin?.name ?? selectedCoin.desc
        
        if self.service.isConnected {
            if let coin = coin,
               let value = self.currencyFormatter.string(from: NSNumber(value: coin.value)) {
                self.value = value
            } else {
                self.value = "Updating..."
            }
        } else {
            self.value = "Offline"
        }
        self.color = self.service.isConnected ? .white : .red
    }
}
