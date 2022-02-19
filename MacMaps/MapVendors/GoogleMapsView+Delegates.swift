//
//  GoogleMapsView+Delegates.swift
//  MacMaps
//
//  Created by Brad Leege on 2/19/22.
//

import Combine
import Foundation
import WebKit

class GoogleMapsViewDelegate: NSObject {
    let mapFinishedLoadingPublisher = PassthroughSubject<Bool, Never>()
}

extension GoogleMapsViewDelegate: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView did finish loading")
        mapFinishedLoadingPublisher.send(true)
    }
    
}
