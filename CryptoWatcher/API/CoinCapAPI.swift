//
//  CoinCapAPI.swift
//  CryptoWatcher
//
//  Created by Arnav Singhal on 28/02/22.
//

import Combine
import Foundation
import Network
import SwiftUI

class CoinCapAPI: NSObject, URLSessionTaskDelegate {
    
    private let session = URLSession(configuration: .default)
    private var wsTask: URLSessionWebSocketTask?
    
    private let coinSubject = CurrentValueSubject<[String: Coin], Never> ([:])
    private var coinDictionary: [String: Coin] { coinSubject.value }
    
    private var connectionStateSubject = CurrentValueSubject<Bool, Never> (false)
    private var isConnected: Bool { connectionStateSubject.value }
    
    func connect() {
        let coins = CoinType.allCases
            .map{ $0.urlText }
            .joined(separator: ",")
        let url = URL(string: "wss://ws.coincap.io/prices?assets=\(coins)")!
        wsTask = session.webSocketTask(with: url)
        wsTask?.delegate = self
        wsTask?.resume()
        self.receiveMessage()
    }
    
    private func receiveMessage() {
        wsTask?.receive { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("String: ", text)
                    if let data = text.data(using: .utf8) {
                        self.onReceive(data)
                    }
                case .data(let data):
                    print("Data: ", data)
                    self.onReceive(data)
                default: break
                }
                self.receiveMessage()
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func onReceive(_ data: Data){
        guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return
        }
        var newDict = [String: Coin]()
        dictionary.forEach { (key, value) in
            let value = Double(value) ?? 0
            newDict[key] = Coin(name: key.capitalized, value: value)
        }
        let mergedDict = coinDictionary.merging(newDict) { $1 }
        coinSubject.send(mergedDict)
    }
    
    func clearTask() {
        self.wsTask?.cancel()
        self.wsTask = nil
        self.connectionStateSubject.send(false)
    }
    
    deinit {
        coinSubject.send(completion: .finished)
        connectionStateSubject.send(completion: .finished)
    }
}

extension CoinCapAPI: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.connectionStateSubject.send(true)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.connectionStateSubject.send(false)
        print("DISCONECTED")
    }
}
