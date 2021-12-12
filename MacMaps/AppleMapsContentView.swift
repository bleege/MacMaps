//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import MapKit
import SwiftUI

struct AppleMapsContentView: View {

    @ObservedObject
    private var viewModel = AppleMapsContentViewModel()

    var body: some View {
        // TODO: Override Map in order to use MKMapView functionality
        Map(coordinateRegion: $viewModel.mapRegion).toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu("Map Type") {
                    ForEach(viewModel.mapTypes) { mapType in
                        Button(mapType.name, action: { viewModel.selectedMapType = mapType })
                    }
                }
            }
        }
    }

}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapsContentView()
    }
}
