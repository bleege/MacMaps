//
//  ContentView.swift
//  MacMaps
//
//  Created by Brad Leege on 11/30/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Hello, world!")
                    .padding()
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
