//
//  NewsFeedView.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/7/22.
//

import CoreLocationUI
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel(weatherRepository: WeatherWebRepository(), locationRepository: LocationRepository())

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error, retryAction: { viewModel.load() })
            case .success:
                CurrentWeatherView(viewModel: viewModel.currentWeatherViewModel())
            }
        }
        .onAppear(perform: viewModel.load)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
