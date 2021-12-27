//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import Combine
import MapKit
import SwiftUI

struct AppleMapsContentView: View {

    @ObservedObject
    private var viewModel = AppleMapsContentViewModel()
    private let appleMapView = AppleMapsView()
    
    var body: some View {
        appleMapView.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu("Map Type") {
                    ForEach(viewModel.mapTypes) { mapType in
                        Button(mapType.name, action: { viewModel.selectedMapType = mapType })
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.toggleLocationMonitoring()
                }) {
                    Image(systemName: viewModel.locationButtonImageName)
                }
            }
        }
        .onReceive(viewModel.$mapRegion, perform: { region in
            appleMapView.mapView.region = region
        })
        .onReceive(viewModel.$selectedMapType, perform: { mapType in
            appleMapView.mapView.mapType = mapType
        })
        .onReceive(viewModel.$showUserLocation, perform: { showUserLocation in
            appleMapView.mapView.showsUserLocation = showUserLocation
        })
    }
    
}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapsContentView()
    }
}
