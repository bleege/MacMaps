//
//  AppleMapsViewModel.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import Combine
import CoreLocation
import MapKit
import GeoJSON

class MapContentViewModel: ObservableObject {
    
    enum MapVendor: String, CaseIterable {
        case appleMaps = "Apple Maps"
        case mapbox = "Mapbox"
    }
    
    enum MapboxStyles: String, CaseIterable {
        case streets = "Streets"
        case outdoors = "Outdoors"
        case light = "Light"
        case dark = "Dark"
        case satellite = "Satellite"
        case satelliteStreets = "Satellite Streets"
        case navigationDay = "Navigation Day"
        case navigationNight = "Navigation Night"
        
        var styleURL: String {
            switch self {
            case .streets:
                return "mapbox://styles/mapbox/streets-v11"
            case .outdoors:
                return "mapbox://styles/mapbox/outdoors-v11"
            case .light:
                return "mapbox://styles/mapbox/light-v10"
            case .dark:
                return "mapbox://styles/mapbox/dark-v10"
            case .satellite:
                return "mapbox://styles/mapbox/satellite-v9"
            case .satelliteStreets:
                return "mapbox://styles/mapbox/satellite-streets-v11"
            case .navigationDay:
                return "mapbox://styles/mapbox/navigation-day-v1"
            case .navigationNight:
                return "mapbox://styles/mapbox/navigation-night-v1"
            }
        }
    }
    
    @Published
    var mapVendor: MapVendor = .mapbox
    
    @Published
    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421),
                                       span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published
    var selectedAppleMapType = MKMapType.standard
    
    @Published
    var selectedMapboxMapStyle: MapboxStyles = .streets
    
    @Published
    var locationButtonImageName = "location.fill"
    
    @Published
    var showUserLocation = true
    
    @Published
    var searchQuery = ""
    
    @Published
    var searchSuggestions = [CLPlacemark]()
    
    @Published
    var searchResultApplePlacemark: CLPlacemark?
    
    @Published
    var searchResultMapboxFeature: Feature?
    
    let searchCancelledPublisher = PassthroughSubject<Bool, Never>()
    
    let appleMapsTypes: [MKMapType] = [.standard, .satellite, .hybrid, .satelliteFlyover, .hybridFlyover, .mutedStandard]
    
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
        
        print("searchQuery = \(searchQuery)")
        
        if mapVendor == .appleMaps {

            geocoder.geocodeAddressString(searchQuery) { [weak self] placemarks, error in
                if let error = error {
                    print("Error geocoding: \(error)")
                    return
                }
                
                print("placemark(s) found = \(String(describing: placemarks))")
                if let placemarks = placemarks, placemarks.count > 1 {
                    self?.searchSuggestions.removeAll()
                    self?.searchSuggestions.append(contentsOf: placemarks)
                    return
                } else {
                    self?.searchSuggestions.removeAll()
                }
                
                if let placemark = placemarks?[0] {
                    self?.searchResultApplePlacemark = placemark
                }
                
            }
        } else if mapVendor == .mapbox {
                        
            guard let fileName = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            let urlString = "https://api.mapbox.com/geocoding/v5/mapbox.places/\(fileName).json?access_token=pk.eyJ1IjoiYmxlZWdlIiwiYSI6InRIWGRhQTgifQ.aqpWzaYuYupQd78KaSK_SA"
                        
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap() {
                    return $0.data
                }
                .decode(type: FeatureCollection.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    print("Received completion for Mapbox Geocode Request")
                }, receiveValue: { [weak self] featureCollection in
                    print("Received featureCollection from Geocode Search")
                    
                    if let feature = featureCollection.features.first {
                        self?.searchResultMapboxFeature = feature
                    }
                })
                .store(in: &cancellables)
            
        }
        
    }
}
