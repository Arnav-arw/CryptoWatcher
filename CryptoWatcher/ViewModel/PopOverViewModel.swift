//
//  PopOverViewModel.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 08/03/22.
//

import Foundation
import Combine
import SwiftUI

class popoverViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var subtitle: String
    @Published private(set) var coinTypes: [CoinType]
    @AppStorage("SelectedCoinType") var selectedCoin = CoinType.bitcoin
    
    private let service: CoinCapAPI
    private var subscriptions = Set<AnyCancellable>()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    init(title: String = "", subtitle: String = "", coinTypes: [CoinType] = CoinType.allCases, service: CoinCapAPI = .init()) {
        self.title = title
        self.subtitle = subtitle
        self.coinTypes = coinTypes
        self.service = service
    }
    
    func subToService() {
        service.coinSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.updateView() }
            .store(in: &subscriptions)
    }
    
    func updateView() {
        let coin = self.service.coinDictionary[selectedCoin.rawValue]
        self.title = coin?.name ?? selectedCoin.desc
        
        if self.service.isConnected {
            if let coin = coin,
               let value = self.currencyFormatter.string(from: NSNumber(value: coin.value)) {
                self.subtitle = value
            } else {
                self.subtitle = "Updating..."
            }
        } else {
            self.subtitle = "Offline"
        }
    }
    
    func valueText(for coinTypes: CoinType) -> String {
        if let coin = service.coinDictionary[coinTypes.rawValue],
           let value = self.currencyFormatter.string(from: NSNumber(value: coin.value)) {
            return value
        } else {
            return "Updating..."
        }
    }
}
