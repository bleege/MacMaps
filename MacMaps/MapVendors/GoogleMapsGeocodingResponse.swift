//
//  GoogleMapsGeocodingResponse.swift
//  MacMaps
//
//  Created by Brad Leege on 2/7/22.
//

import Foundation

struct GoogleMapsGeocodingResponse: Codable {
    
    let results: [Results]
    
    struct Results: Codable {
        let formattedAddress: String
        let geometry: Geometry
        let placeId: String
        
        enum CodingKeys: String, CodingKey {
            case formattedAddress = "formatted_address"
            case geometry
            case placeId = "place_id"
        }
    }
    
    struct Geometry: Codable {
        let location: Location
    }
    
    struct Location: Codable {
        let lat: Double
        let lng: Double
    }
    
}
