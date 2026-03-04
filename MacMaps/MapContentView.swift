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

    @State
    private var viewModel = MapContentViewModel()
    
    // Map Vendors
    private let appleMapView = AppleMapsView()
    private let googleMapsView = GoogleMapsView()
    private let mapboxMapView = MapboxMapsView()
    
    @Environment(\.isSearching) private var isSearching: Bool
    
    var body: some View {
        mapContent
            .toolbar {
                toolbarContent(Bindable(viewModel))
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
            .onChange(of: viewModel.searchQuery) { _, newValue in
                if newValue.isEmpty && !isSearching {
                    print("Search is cancelled")
                    viewModel.searchCancelledPublisher.send(true)
                }
            }
            .onChange(of: viewModel.mapRegion) { _, newValue in
                handleMapRegionChange(newValue)
            }
            .onChange(of: viewModel.selectedAppleMapType, handleAppleMapTypeChange)
            .onChange(of: viewModel.selectedMapboxMapStyle, handleMapboxStyleChange)
            .onChange(of: viewModel.selectedGoogleMapStyle, handleGoogleStyleChange)
            .onChange(of: viewModel.showUserLocation, handleUserLocationChange)
            .onChange(of: viewModel.searchResultPlacemark, handleSearchResultChange)
            .onReceive(viewModel.searchCancelledPublisher) { _ in
                handleSearchCancelled()
            }
    }

    @ViewBuilder
    private var mapContent: some View {
        switch viewModel.mapVendor {
        case .appleMaps:
            appleMapView
        case .mapbox:
            mapboxMapView
        case .googleMaps:
            googleMapsView
        }
    }

    private func handleMapRegionChange(_ newValue: MKCoordinateRegion) {
        switch viewModel.mapVendor {
        case .appleMaps:
            appleMapView.mapView.region = newValue
        case .mapbox:
            mapboxMapView.setCenter(newValue.center)
        case .googleMaps:
            googleMapsView.setCenter(newValue.center)
        }
    }

    private func handleAppleMapTypeChange(_: MKMapType, _ newValue: MKMapType) {
        appleMapView.mapView.mapType = newValue
    }

    private func handleMapboxStyleChange(_: MapContentViewModel.MapboxStyles, _ newValue: MapContentViewModel.MapboxStyles) {
        mapboxMapView.changeMapStyle(newValue)
    }

    private func handleGoogleStyleChange(_: MapContentViewModel.GoogleMapStyles, _ newValue: MapContentViewModel.GoogleMapStyles) {
        googleMapsView.changeMapStyle(newValue)
    }

    private func handleUserLocationChange(_: Bool, _ newValue: Bool) {
        switch viewModel.mapVendor {
        case .appleMaps:
            appleMapView.mapView.showsUserLocation = newValue
        case .mapbox:
            if newValue {
                mapboxMapView.showUserLocation(viewModel.mapRegion.center)
            } else {
                mapboxMapView.hideUserLocation()
            }
        case .googleMaps:
            if newValue {
                googleMapsView.showUserLocation(viewModel.mapRegion.center)
            } else {
                googleMapsView.hideUserLocation()
            }
        }
    }

    private func handleSearchResultChange(_: CLPlacemark?, _ newValue: CLPlacemark?) {
        guard let placemark = newValue else { return }
        switch viewModel.mapVendor {
        case .appleMaps:
            appleMapView.showMarker(placemark)
        case .mapbox:
            mapboxMapView.showMarker(placemark)
        case .googleMaps:
            googleMapsView.showMarker(placemark)
        }
    }

    private func handleSearchCancelled() {
        switch viewModel.mapVendor {
        case .appleMaps:
            appleMapView.clearMarker()
        case .mapbox:
            mapboxMapView.clearMarker()
        case .googleMaps:
            googleMapsView.clearMarker()
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent(_ bindable: Bindable<MapContentViewModel>) -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Picker("Map Vendor", selection: bindable.mapVendor) {
                ForEach(MapContentViewModel.MapVendor.allCases, id: \.rawValue) { vendor in
                    Text(vendor.rawValue).tag(vendor)
                }
            }
        }
        ToolbarItem(placement: .primaryAction) {
            switch viewModel.mapVendor {
            case .appleMaps:
                Picker("Apple Styles", selection: bindable.selectedAppleMapType) {
                    ForEach(MapContentViewModel.AppleMapTypes.allCases) { mapType in
                        Text(mapType.rawValue).tag(mapType.type)
                    }
                }
            case .mapbox:
                Picker("Mapbox Styles", selection: bindable.selectedMapboxMapStyle) {
                    ForEach(MapContentViewModel.MapboxStyles.allCases) { mapStyle in
                        Text(mapStyle.rawValue).tag(mapStyle)
                    }
                }
            case .googleMaps:
                Picker("Google Styles", selection: bindable.selectedGoogleMapStyle) {
                    ForEach(MapContentViewModel.GoogleMapStyles.allCases) { mapStyle in
                        Text(mapStyle.rawValue).tag(mapStyle)
                    }
                }
            }
        }
        ToolbarItem(placement: .primaryAction) {
            Button {
                viewModel.toggleLocationMonitoring()
            } label: {
                Image(systemName: viewModel.locationButtonImageName)
            }
        }
    }

}

#Preview {
    MapContentView()
}
