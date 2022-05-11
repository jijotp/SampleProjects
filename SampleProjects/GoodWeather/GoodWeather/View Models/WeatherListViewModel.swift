//
//  WeatherListViewModel.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/4/21.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation
@MainActor
class WeatherListViewModel {
    
    private var weatherViewModels = [WeatherViewModel]()
    @Published var news = [ArticleListViewModel]()
    
    func addWeatherViewModel(_ vm: WeatherViewModel) {
        weatherViewModels.append(vm)
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return weatherViewModels.count
    }
    
    func modelAt(_ index: Int) -> WeatherViewModel {
        return weatherViewModels[index]
    }
    
    private func fetchNews() {
        WebService().getNews(with: [Article].self) { result in
            
            switch result {
            case .success(let stocks):
                DispatchQueue.main.async {
                    if let news = stocks as? [Article] {
                        self.news = news.map(ArticleListViewModel.init)
                        debugPrint(self.news.count)
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
  
}

class WeatherViewModel {
    
    let weather: WeatherResponse
    
    init(weather: WeatherResponse) {
        self.weather = weather
    }
    
    var city: String {
        return weather.name
    }
    
    var temperature: Double {
        return weather.main.temp 
    }
    
}


