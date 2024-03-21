//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Lucas  Felipe on 01/02/2024.
//

import SwiftUI
import Foundation

struct ResponseWeather: Hashable, Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Hashable, Codable {
    let time: String
    let temperature_2m: Float
}

class WeatherViewModel: ObservableObject {
    
    @Published var currentWeather: CurrentWeather = CurrentWeather(time: "2024-03-21T14:15", temperature_2m: 13.9)
    
    func getWeather(latitude: Double, longitude: Double) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data, error == nil else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(ResponseWeather.self, from: data)
                DispatchQueue.main.async {
                    self?.currentWeather = json.current
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
}

struct City {
    let name: String
    let longitude: Double
    let latitude: Double
}


struct ContentView: View {
    
    @State private var isNight = false
    @StateObject var viewModel = WeatherViewModel()
    @State private var selectedCity = City(name: "Cupertino, CA", longitude: -122.0675015, latitude: 37.3112558)
    
    private var weatherDays = [
        WeatherDay(dayOfWeek: "TUE",
                   imageName: "cloud.sun.fill",
                   temperature: 74),
        WeatherDay(dayOfWeek: "WED",
                   imageName: "sun.max.fill",
                   temperature: 74),
        WeatherDay(dayOfWeek: "THU",
                   imageName: "wind",
                   temperature: 74),
        WeatherDay(dayOfWeek: "FRI",
                   imageName: "sunset.fill",
                   temperature: 74),
        WeatherDay(dayOfWeek: "SAT",
                   imageName: "snow",
                   temperature: 74)
    ]
    
    private var cities: Array<City> = [
        City(name: "Cupertino, CA", longitude: -122.0675015, latitude: 37.3112558),
        City(name: "Lisboa", longitude: -9.2009353, latitude: 38.7441392),
        City(name: "Tel Aviv", longitude: 34.7560464, latitude: 32.0879976)
    ]
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: selectedCity.name)
                
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill",
                                      temperature: Int(viewModel.currentWeather.temperature_2m))
                
                HStack(spacing: 14) {
                    ForEach(weatherDays) { weatherDay in
                        WeatherDayView(dayOfWeek: weatherDay.dayOfWeek,
                                       imageName: weatherDay.imageName,
                                       temperature: weatherDay.temperature)
                    }
                }
                
                Spacer()
                
                Button {
                    isNight.toggle()
                    selectedCity = cities[1]
                    viewModel.getWeather(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                        .frame(width: 280, height: 50)
                        .background(Color.white)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.getWeather(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
            }
            
        }
    }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding()
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [
            isNight ? .black : .blue,
            isNight ? .gray : Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 34, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}


struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
            
        }
        .padding(.bottom, 40)
    }
}
