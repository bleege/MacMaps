//
//  LocationManager.swift
//  MacMaps
//
//  Created by Brad Leege on 12/21/21.
//

import CoreLocation
import Observation

@MainActor
@Observable
class LocationManager {

    public static let shared = LocationManager()

    private(set) var currentCoordinate = CLLocationCoordinate2D(latitude: 50.45031, longitude: 30.53992)
    private(set) var isMonitoringLocation = false

    private var monitoringTask: Task<Void, Never>?

    private init() {}

    func startLocationMonitoring() {
        print("startLocationMonitoring")
        guard monitoringTask == nil else { return }
        isMonitoringLocation = true
        monitoringTask = Task {
            do {
                for try await update in CLLocationUpdate.liveUpdates() {
                    guard !Task.isCancelled else { break }
                    if let location = update.location {
                        currentCoordinate = location.coordinate
                    }
                }
            } catch {
                print("Location error: \(error)")
            }
            isMonitoringLocation = false
        }
    }

    func stopLocationMonitoring() {
        print("stopLocationMonitoring")
        monitoringTask?.cancel()
        monitoringTask = nil
        isMonitoringLocation = false
    }

}
