//
//  ViewController.swift
//  TheAdventureOfBatman
//
//  Created by Cenker Soyak on 23.10.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var gbpLabel = UILabel()
    var tryLabel = UILabel()
    var usdLabel = UILabel()
    var cadLabel = UILabel()
    var jpyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI(){
        view.backgroundColor = .white
        
        let currencyConverterText = UILabel()
        currencyConverterText.text = "Currency Converter 2023"
        currencyConverterText.font = .systemFont(ofSize: 25)
        currencyConverterText.textAlignment = .center
        view.addSubview(currencyConverterText)
        currencyConverterText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.right.equalToSuperview().inset(50)
        }
        gbpLabel.text = "GBP: "
        gbpLabel.font = .systemFont(ofSize: 20)
        gbpLabel.textAlignment = .center
        view.addSubview(gbpLabel)
        gbpLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyConverterText.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        tryLabel.text = "TRY: "
        tryLabel.font = .systemFont(ofSize: 20)
        tryLabel.textAlignment = .center
        view.addSubview(tryLabel)
        tryLabel.snp.makeConstraints { make in
            make.top.equalTo(gbpLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        usdLabel.text = "USD: "
        usdLabel.font = .systemFont(ofSize: 20)
        usdLabel.textAlignment = .center
        view.addSubview(usdLabel)
        usdLabel.snp.makeConstraints { make in
            make.top.equalTo(tryLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        cadLabel.text = "CAD: "
        cadLabel.font = .systemFont(ofSize: 20)
        cadLabel.textAlignment = .center
        view.addSubview(cadLabel)
        cadLabel.snp.makeConstraints { make in
            make.top.equalTo(usdLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        jpyLabel.text = "JPY: "
        jpyLabel.font = .systemFont(ofSize: 20)
        jpyLabel.textAlignment = .center
        view.addSubview(jpyLabel)
        jpyLabel.snp.makeConstraints { make in
            make.top.equalTo(cadLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        let getRatesButton = UIButton()
        getRatesButton.setTitle("Get Rates", for: .normal)
        getRatesButton.configuration = .filled()
        view.addSubview(getRatesButton)
        getRatesButton.addTarget(self, action: #selector(getRatesTapped), for: .touchUpInside)
        getRatesButton.snp.makeConstraints { make in
            make.top.equalTo(jpyLabel.snp.bottom).offset(100)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func getRatesTapped(){
        
        // 1) Request & Session
        
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=eda97a643d9eef2a0cafb410858d37e9")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            } else {
                // 2) Response & Data
                if data != nil {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        //ASYNC
                        DispatchQueue.main.async {
                            // 3) Parsing & JSON Serialization
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                //Rates
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let trY = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY: \(trY)"
                                }
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                            }
                        }
                    } catch {
                        print("error")
                    }
                }
            }
        }
        task.resume()
    }
}
