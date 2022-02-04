//
//  GoogleMapsView.swift
//  MacMaps
//
//  Created by Brad Leege on 2/1/22.
//

import Foundation
import SwiftUI
import WebKit

final class GoogleMapsView: NSViewRepresentable {
    
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
        guard let url = Bundle.main.url(forResource: "google-maps", withExtension: "html") else { return }
        webView.load(URLRequest(url: url))
    }
}
