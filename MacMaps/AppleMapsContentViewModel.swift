//
//  AppleMapsViewModel.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import Combine
import MapKit

class AppleMapsContentViewModel: ObservableObject {
    
    @Published
    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421),
                                       span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published
    var selectedMapType = MKMapType.standard {
        didSet {
            print("New mapType = \(selectedMapType.rawValue)")
        }
    }

    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid, .satelliteFlyover, .hybridFlyover, .mutedStandard]

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        LocationManager.shared.currentLocation.sink(receiveValue: { [weak self] location in
            self?.mapRegion.center = location.coordinate
        }).store(in: &cancellables)
    }
    
}
