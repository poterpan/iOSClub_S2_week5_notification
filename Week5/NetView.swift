//
//  NetView.swift
//  Week5
//
//  Created by Poter Pan on 2023/4/18.
//

import SwiftUI

struct DataModel: Codable {
    internal init() {
        self.ip = "unknow"
        self.region = "unknow"
        self.timezone = "unknow"
    }
    
    let ip: String
    let region: String
    let timezone: String
}

class NetViewModel: ObservableObject {
    @Published var netdata: DataModel = DataModel()
    
    init() {
        fetchAPI2()
    }
    
    func fetchAPI() {
        
//        iOS 16 前，請使用
//        if let urlString = "https://ipapi.co/json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//        let url = URL(string: urlString)
        
        let urlString = "https://ipapi.co/json"
        if let url = URLComponents(string: urlString)?.url {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data {
                    do {
                        let netdata = try JSONDecoder().decode(DataModel.self, from: data)
                        DispatchQueue.main.async {
                            self.netdata = netdata
                        }
                        print(netdata)
                    } catch {
                        print(error)
                    }
                } else if let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    func fetchAPI2() {
        let urlString = "https://ipapi.co/json"
        if let url = URLComponents(string: urlString)?.url {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let decoder = JSONDecoder()
                    let netdata = try decoder.decode(DataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.netdata = netdata
                    }
                    print(netdata)
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct NetView: View {
    
    @StateObject var netVM = NetViewModel()

    var body: some View {
        Text("目前IP位置: \(netVM.netdata.ip)")
    }
}

struct NetView_Previews: PreviewProvider {
    static var previews: some View {
        NetView()
    }
}



//{
//    "ip": "61.218.155.31",
//    "network": "61.218.144.0/20",
//    "version": "IPv4",
//    "city": "Taichung",
//    "region": "Taichung City",
//    "region_code": "TXG",
//    "country": "TW",
//    "country_name": "Taiwan",
//    "country_code": "TW",
//    "country_code_iso3": "TWN",
//    "country_capital": "Taipei",
//    "country_tld": ".tw",
//    "continent_code": "AS",
//    "in_eu": false,
//    "postal": null,
//    "latitude": 24.144,
//    "longitude": 120.6844,
//    "timezone": "Asia/Taipei",
//    "utc_offset": "+0800",
//    "country_calling_code": "+886",
//    "currency": "TWD",
//    "currency_name": "Dollar",
//    "languages": "zh-TW,zh,nan,hak",
//    "country_area": 35980.0,
//    "country_population": 23451837,
//    "asn": "AS3462",
//    "org": "Data Communication Business Group"
//}
