//
//  AppleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 12/5/21.
//

import MapKit
import SwiftUI

struct AppleMapsView: View {

    @ObservedObject
    private var viewModel = AppleMapsViewModel()

    var body: some View {
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
        AppleMapsView()
    }
}
