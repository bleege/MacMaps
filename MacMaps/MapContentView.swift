//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import Combine
import MapKit
import SwiftUI

struct MapContentView: View {

    @ObservedObject
    private var viewModel = MapContentViewModel()
    
    // Map Vendors
    private let appleMapView = AppleMapsView()
    private let googleMapsView = GoogleMapsView()
    private let mapboxMapView = MapboxMapsView()
    
    @Environment(\.isSearching) private var isSearching: Bool
    
    var body: some View {
        HStack {
            switch viewModel.mapVendor {
            case .appleMaps:
                appleMapView
            case .mapbox:
                mapboxMapView
            case .googleMaps:
                googleMapsView
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                VStack {
                    Picker("Map Vendor", selection: $viewModel.mapVendor) {
                        ForEach(MapContentViewModel.MapVendor.allCases, id: \.rawValue) { vendor in
                            Text(vendor.rawValue).tag(vendor)
                        }
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                VStack {
                    switch viewModel.mapVendor {
                    case .appleMaps:
                        Picker("Apple Styles", selection: $viewModel.selectedAppleMapType) {
                            ForEach(MapContentViewModel.AppleMapTypes.allCases) { mapType in
                                Text(mapType.rawValue).tag(mapType.type)
                            }
                        }
                    case .mapbox:
                        Picker("Mapbox Styles", selection: $viewModel.selectedMapboxMapStyle) {
                            ForEach(MapContentViewModel.MapboxStyles.allCases) { mapStyle in
                                Text(mapStyle.rawValue).tag(mapStyle)
                            }
                        }
                    case .googleMaps:
                        Picker("Google Styles", selection: $viewModel.selectedGoogleMapStyle) {
                            ForEach(MapContentViewModel.GoogleMapStyles.allCases) { mapStyle in
                                Text(mapStyle.rawValue).tag(mapStyle)
                            }
                        }
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
        .searchable(text: $viewModel.searchQuery,
                    prompt: "Search...",
                    suggestions: {
            ForEach(viewModel.searchSuggestions, id: \.self) { suggestion in
                Text(suggestion.name ?? "")
                    .searchCompletion(suggestion.name ?? "")
            }
        })
        .onSubmit(of: .search) {
            viewModel.searchForLocation()
        }
        .onChange(of: viewModel.searchQuery) { query in
            if viewModel.searchQuery.isEmpty && !isSearching {
                print("Search is cancelled")
                viewModel.searchCancelledPublisher.send(true)
            }
        }
        .onReceive(viewModel.$mapRegion, perform: { region in
            switch viewModel.mapVendor {
            case .appleMaps:
                appleMapView.mapView.region = region
            case .mapbox:
                mapboxMapView.setCenter(region.center)
            case .googleMaps:
                googleMapsView.setCenter(region.center)
            }
        })
        .onReceive(viewModel.$selectedAppleMapType, perform: { mapType in
            appleMapView.mapView.mapType = mapType
        })
        .onReceive(viewModel.$selectedMapboxMapStyle, perform: { mapStyle in
            mapboxMapView.changeMapStyle(mapStyle)
        })
        .onReceive(viewModel.$selectedGoogleMapStyle, perform: { mapStyle in
            googleMapsView.changeMapStyle(mapStyle)
        })
        .onReceive(viewModel.$showUserLocation, perform: { showUserLocation in
            switch viewModel.mapVendor {
            case .appleMaps:
                appleMapView.mapView.showsUserLocation = showUserLocation
            case .mapbox:
                if showUserLocation {
                    mapboxMapView.showUserLocation(viewModel.mapRegion.center)
                } else {
                    mapboxMapView.hideUserLocation()
                }
            case .googleMaps:
                if showUserLocation {
                    googleMapsView.showUserLocation(viewModel.mapRegion.center)
                } else {
                    googleMapsView.hideUserLocation()
                }
            }
        })
        .onReceive(viewModel.$searchResultPlacemark, perform: { placemark in
            guard let placemark = placemark else { return }
            switch viewModel.mapVendor {
            case .appleMaps:
                appleMapView.showMarker(placemark)
            case .mapbox:
                mapboxMapView.showMarker(placemark)
            case .googleMaps:
                googleMapsView.showMarker(placemark)
            }
        })
        .onReceive(viewModel.searchCancelledPublisher, perform: { didCancel in
            switch viewModel.mapVendor {
            case .appleMaps:
                appleMapView.clearMarker()
            case .mapbox:
                mapboxMapView.clearMarker()
            case .googleMaps:
                googleMapsView.clearMarker()
            }
        })
    }
    
}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView()
    }
}
