//
//  AppleMapsViewModel.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import Combine
import CoreLocation
import MapKit

class AppleMapsContentViewModel: ObservableObject {
    
    @Published
    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421),
                                       span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published
    var selectedMapType = MKMapType.standard
    
    @Published
    var locationButtonImageName = "location.fill"
    
    @Published
    var showUserLocation = true
    
    @Published
    var searchQuery = ""

    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid, .satelliteFlyover, .hybridFlyover, .mutedStandard]
    
    private var cancellables = Set<AnyCancellable>()
    
    private let geocoder = CLGeocoder()
    
    init() {
        LocationManager.shared.currentLocation.sink(receiveValue: { [weak self] location in
            self?.mapRegion.center = location.coordinate
        }).store(in: &cancellables)
        
        LocationManager.shared.$isMonitoringLocation.sink(receiveValue: { [weak self] isMonitoring in
            if isMonitoring {
                self?.locationButtonImageName = "location.fill"
                self?.showUserLocation = true
            } else {
                self?.locationButtonImageName = "location.slash.fill"
                self?.showUserLocation = false
            }
        }).store(in: &cancellables)
    }
    
    func toggleLocationMonitoring() {
        if LocationManager.shared.isMonitoringLocation {
            LocationManager.shared.stopLocationMonitoring()
        } else {
            LocationManager.shared.startLocationMonitoring()
        }
    }

    func searchForLocation() {
        
        if searchQuery.isEmpty { return }
        
        geocoder.geocodeAddressString(searchQuery) { placemark, error in
            if let error = error {
                print("Error geocoding: \(error)")
                return
            }
            
            print("placemark(s) found = \(placemark)")
            
        }
        
    }
}
