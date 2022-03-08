//
//  Coin.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 28/02/22.
//

import Foundation

enum CoinType: String, Identifiable, CaseIterable {
    
    case bitcoin
    case ethereum
    case solana
    case dogecoin
    
    var text: String {
        return rawValue.capitalized
    }
    
    var urlText: String {
        return rawValue
    }
    
    var id: Self { self }
    var url: URL { URL(string: "https://coincap.io/assets/\(urlText)")!}
    var desc: String { text }

}
