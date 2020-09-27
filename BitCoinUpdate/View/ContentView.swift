//
//  ContentView.swift
//  BitCoinUpdate
//
//  Created by Appnap WS01 on 24/9/20.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @AppStorage("savedData", store: UserDefaults(suiteName: "group.com.Appnap.BitCoinUpdate"))
    var data: Data = Data()

    
    let loadData = DataModel()
    @State private var selectedIndex = 0
    @State private var currentRate = 0.0
    @State private var currentCurrency = "N/A"

    var body: some View {
        ZStack {
            Image("background_2").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Bit Coin")
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(0)
                    .padding(.all, 20)
                HStack {
                    
                    Image("1024").resizable()
                        .frame(width: 70, height: 70, alignment: .leading)
                        .clipShape(Circle())
                    Text(String(format: "%.2f", currentRate))
                        .bold()
                    Text(currentCurrency)
                        .bold()
                        .padding()
                }
                .padding(.all, 5)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                Spacer()
                
                Picker(selection: $selectedIndex, label: Text("")) {
                    ForEach(0 ..< loadData.currencyArray.count) {
                        Text(self.loadData.currencyArray[$0])
                    }
                }.onChange(of: selectedIndex) { _ in
                    
                    var exchangeData = ExchangeInfo(rate: 0.0, asset_id_quote: "USD")
                    exchangeData.asset_id_quote = loadData.currencyArray[selectedIndex]
                    performRequest(for: loadData.currencyArray[selectedIndex]) { (success, price) in
                        if success == 200{
                            exchangeData.rate = price
                            currentRate = price
                            currentCurrency = loadData.currencyArray[selectedIndex]
                            guard let getData = try? JSONEncoder().encode(exchangeData) else { return }
                            data.self = getData
                            WidgetCenter.shared.reloadTimelines(ofKind: "BitCoinWidget")
                        }
                    }
                }
            }
            .padding(.top, 30)
        }
    }
    
 
    
  
    func performRequest(for currency: String , success: @escaping(_ status: Int, _ price: Double)-> Void) {
        let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
        let apiKey = "CC1A0EFD-A410-4C5E-84B0-F647EC3DD22D"
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        var price = 0.0
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlRes, error) in
                if error != nil {
                    print("Error")
                    success(404, price)
                }
                if let str = data {
                    let info = self.parseJSON(str)
                    price = info!.rate
                    success(200,price)
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ exchangeData: Data) -> ExchangeInfo? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeInfo.self, from: exchangeData)
            let rateData = ExchangeInfo(rate: decodedData.rate, asset_id_quote: decodedData.asset_id_quote)
            return rateData
        }catch {
            print(error)
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}

