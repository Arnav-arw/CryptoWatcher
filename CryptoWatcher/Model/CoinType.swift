//
//  Coin.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 28/02/22.
//

import Foundation

enum CoinType: String, Identifiable, CaseIterable {
    
    case bitcoin
    case etherium
    case solana
    case dogecoin
    case shibainu
    
    var text: String {
        if self == .shibainu {
            return "Shibu Ina"
        }
        return rawValue.capitalized
    }
    
    var urlText: String {
        if self == .shibainu {
            return "shiba-inu"
        }
        return rawValue
    }
    
    var id: Self { self }
    var url: URL { URL(string: "https://coincap.io/assets/\(urlText)")!}
    var desc: String { text }

}
