# MacMaps

Explore the world using different Map Vendors, Styles, and Data all within a native macOS application.

### Vendors

* Apple Maps
* Google Maps
* Mapbox

### Features

* Map Styles per Map Vendor
* Geocoding via Map Vendor
* Multiple Windows for comparison

### Tech Stack

* SwiftUI
* MVVM
* GeoJSON SDK
  * https://github.com/kiliankoe/GeoJSON
  * MIT License

### Known Issues

* Google Maps uses the Google Map JavaScript API and is rendered within a `WKWebView`.  This is due to their iOS SDK not being compatible with macOS.
* Mapbox uses the Mapbox GL JS and is rendered within a `WKWebView`.
  * Out of date Mapbox Maps SDK for macOS is not supported on M1 Macs
  * Mapbox iOS SDK v10 doesn't support macOS
