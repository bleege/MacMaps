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
    private let mapboxMapView = MapboxMapsView()
    
    @Environment(\.isSearching) private var isSearching: Bool
    
    var body: some View {
        HStack {
            if viewModel.mapVendor == .appleMaps {
                appleMapView
            } else if viewModel.mapVendor == .mapbox {
                mapboxMapView
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu("Map Vendor") {
                    ForEach(MapContentViewModel.MapVendor.allCases, id: \.rawValue) { vendor in
                        Button(vendor.rawValue, action: { viewModel.mapVendor = vendor })
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Menu("Map Type") {
                    if viewModel.mapVendor == .appleMaps {
                        ForEach(viewModel.appleMapsTypes) { mapType in
                            Button(mapType.name, action: { viewModel.selectedAppleMapType = mapType })
                        }
                    } else if viewModel.mapVendor == .mapbox {
                        ForEach(MapContentViewModel.MapboxStyles.allCases, id: \.rawValue) { mapStyle in
                            Button(mapStyle.rawValue, action: { viewModel.selectedMapboxMapStyle = mapStyle })
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
            if viewModel.mapVendor == .appleMaps {
                appleMapView.mapView.region = region
            } else if viewModel.mapVendor == .mapbox {
                mapboxMapView.setCenter(region.center)
            }
        })
        .onReceive(viewModel.$selectedAppleMapType, perform: { mapType in
            appleMapView.mapView.mapType = mapType
        })
        .onReceive(viewModel.$selectedMapboxMapStyle, perform: { mapStyle in
            mapboxMapView.changeMapStyle(mapStyle)
        })
        .onReceive(viewModel.$showUserLocation, perform: { showUserLocation in
            appleMapView.mapView.showsUserLocation = showUserLocation
        })
        .onReceive(viewModel.$searchResultApplePlacemark, perform: { placemark in
            guard let placemark = placemark else { return }
            appleMapView.showMarker(placemark)
        })
        .onReceive(viewModel.$searchResultMapboxFeature, perform: { feature in
            guard let feature = feature else { return }
            mapboxMapView.showMarker(feature)
        })
        .onReceive(viewModel.searchCancelledPublisher, perform: { didCancel in
            if viewModel.mapVendor == .appleMaps {
                appleMapView.clearMarker()
            } else if viewModel.mapVendor == .mapbox {
                mapboxMapView.clearMarker()
            }
        })
    }
    
}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView()
    }
}
