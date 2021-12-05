//
//  ContentView.swift
//  MacMaps
//
//  Created by Brad Leege on 11/30/21.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @State
    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.07472, longitude: -89.38421),
                                       span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        NavigationView {
            Text("Navigation Items")
            Map(coordinateRegion: $mapRegion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
