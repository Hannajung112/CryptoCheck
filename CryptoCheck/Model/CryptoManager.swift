//
//  CryptoManager.swift
//  CryptoCheck
//
//  Created by Hanna Jung on 26/5/2564 BE.
//

import Foundation

protocol CryptoManagerDelegate {
    func didUpdatePrice(price: String, crypto: String)
    func didFailWithError(error: Error)
}

struct CryptoManager {
    
    
    var delegate : CryptoManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    
    //insert an api(You can get it from coinapi.io)
    let apiKey = "Type your own api"
    
    //Put any shortcut of the currency that you want
    let thaiBaht = "THB"
    
    let cyptoCurrencyArray = ["BTC","ETH","USDT","BNB","ADA","DOGE","XRP","USDC","DOT","ICP","UNI","BCH","LTC","LINK","MATIC","XLM","BUSD","ETC","SOL","VET","WBTC","DREP","THETA","TRX","EOS","FIL","DAI","AAVE","XMR","NEO"]
    
    
    func getPrice(for crypto : String) {
        
        let urlString = "\(baseURL)/\(crypto)/\(thaiBaht)?apikey=\(apiKey)"
        
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let cyptoPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", cyptoPrice)
                        self.delegate?.didUpdatePrice(price: priceString, crypto: crypto)
                        
                    }
                }
            }
            task.resume()
            
        }
        
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(CryptoData.self, from: data)
            let lastPrice = decoderData.rate
            print(lastPrice)
            return lastPrice
            
        } catch  {
            delegate?.didFailWithError(error:error)
            return nil
        }
    }
    
}
