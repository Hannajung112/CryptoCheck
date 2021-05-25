//
//  ViewController.swift
//  CryptoCheck
//
//  Created by Hanna Jung on 26/5/2564 BE.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    @IBOutlet weak var CryptoLabel: UILabel!
    
    var cryptoManager = CryptoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cryptoManager.delegate = self
        cryptoPicker.dataSource = self
        cryptoPicker.delegate = self
    }


}


//MARK: - CoinManagerDelegate

extension ViewController : CryptoManagerDelegate {
    
    func didUpdatePrice(price: String, crypto: String) {
        DispatchQueue.main.async {
            self.PriceLabel.text = price
            self.CryptoLabel.text = crypto
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - PickerView

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoManager.cyptoCurrencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoManager.cyptoCurrencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCrypto = cryptoManager.cyptoCurrencyArray[row]
        cryptoManager.getPrice(for: selectedCrypto)
    }
    
    
}
