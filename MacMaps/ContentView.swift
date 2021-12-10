//
//  ContentView.swift
//  MacMaps
//
//  Created by Brad Leege on 11/30/21.
//

import MapKit
import SwiftUI

struct ContentView: View {
       
    @State var selectedMapType = MKMapType.standard
    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid, .satelliteFlyover, .hybridFlyover, .mutedStandard]
    
    var body: some View {
        VStack {
            AppleMapsView().toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Map Type") {
                        ForEach(mapTypes) { mapType in
                            Button(mapType.name, action: { selectedMapType = mapType })
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension MKMapType: Identifiable {

    // Identifiable
    public var id: Self { self }
    
    // Custom Name
    var name: String {
        
        switch self {
        case .standard:
            return "Standard"
        case .satellite:
            return "Satellite"
        case .hybrid:
            return "Hybrid"
        case .satelliteFlyover:
            return "Satellite Flyover"
        case .hybridFlyover:
            return "Hybrid Flyover"
        case .mutedStandard:
            return "Muted Standard"
        @unknown default:
            return "Unkown Default"
        }
        
    }
    
}

