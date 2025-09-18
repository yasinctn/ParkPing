//
//  MapView.swift
//  ParkPing
//
//  Created by Yasin Cetin on 11.09.2025.
//

import SwiftUI
import MapKit

// MARK: - MapView Component
struct MapView: UIViewRepresentable {
    let parkingSpot: ParkingSpotEntity
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        // Configure map appearance
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear existing annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add parking spot annotation
        let annotation = ParkingAnnotation(parkingSpot: parkingSpot)
        uiView.addAnnotation(annotation)
        
        // Set region to show parking spot
        let coordinate = CLLocationCoordinate2D(
            latitude: parkingSpot.latitude,
            longitude: parkingSpot.longitude
        )
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is ParkingAnnotation else { return nil }
            
            let identifier = "ParkingPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                // Custom parking pin image
                let pinImage = UIImage(systemName: "car.circle.fill")?
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                
                annotationView?.image = pinImage
                
                // Add directions button to callout
                let directionsButton = UIButton(type: .detailDisclosure)
                directionsButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
                annotationView?.rightCalloutAccessoryView = directionsButton
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
