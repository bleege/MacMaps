//
//  ContentView.swift
//  MacMaps
//
//  Created by Brad Leege on 11/30/21.
//

import MapKit
import SwiftUI

struct ContentView: View {
       
    @State var isShowingPopover = false
    
    var body: some View {
        VStack {
            AppleMapsView().toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isShowingPopover.toggle()
                    }, label: {
                        Text("Map Type")
                    }).popover(isPresented: $isShowingPopover, content: {
                        Text("Map Types Go Here")
                            .padding()
                            .frame(width: 320, height: 100)
                    })
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
