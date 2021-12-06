//
//  ContentView.swift
//  MacMaps
//
//  Created by Brad Leege on 11/30/21.
//

import MapKit
import SwiftUI

struct ContentView: View {
        
    var body: some View {
        NavigationView {
            Text("Navigation Items")
            AppleMapsView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
