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
        Map(coordinateRegion: $viewModel.mapRegion)
    }

}

struct AppleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapsView()
    }
}
