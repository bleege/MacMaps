//
//  MapboxMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 1/19/22.
//

import Foundation
import SwiftUI
import WebKit

struct MapboxMapsView: NSViewRepresentable {
     
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()

        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let url = Bundle.main.url(forResource: "mapbox", withExtension: "html") else { return }
        webView.load(URLRequest(url: url))
    }
    
}
