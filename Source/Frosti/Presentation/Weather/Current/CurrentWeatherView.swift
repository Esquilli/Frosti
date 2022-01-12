//
//  CurrentWeatherView.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/10/22.
//

import CoreLocation
import SwiftUI

struct CurrentWeatherView: View {
    private var viewModel: CurrentWeatherViewModel?
    
    init(viewModel: CurrentWeatherViewModel?) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 200) {
            VStack {
                Text(viewModel?.currentCity ?? "--")
                    .foregroundColor(.primary)
                    .font(.system(size: 40, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                Text(viewModel?.currentWeatherDescription ?? "--")
                    .foregroundColor(.primary)
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            
            viewModel?.currentWeatherIcon
                .font(.system(size: 100))
                .foregroundColor(Color.primary)
            
            VStack {
                Text(viewModel?.currentTemp ?? "")
                    .foregroundColor(.primary)
                    .font(.system(size: 60, weight: .heavy))
                    .multilineTextAlignment(.center)
                
                Text(viewModel?.currentFeelsLike ?? "")
                    .foregroundColor(.primary)
                    .font(.system(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(viewModel: .init(currentWeather: WeatherSummary.fake().current))
    }
}
