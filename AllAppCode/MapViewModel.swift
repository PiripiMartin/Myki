//
//  MapViewModel.swift
//  MykiInspectors
//
//  Created by Piripi Martin on 28/8/2024.
//
import SwiftUI
import MapKit
import Foundation
import Combine

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

struct ListOneResponse: Decodable {
    let list_one: [[String]]  // Updated to handle the array of arrays of strings
}


final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var arrayOfInts2: [[Double]] = []
       
       
       private var cancellables = Set<AnyCancellable>()
       
       func fetchCoordinates() {
           guard let url = URL(string: "https://inspectorapi.fly.dev/api/lists") else {
               print("Invalid URL")
               return
           }

           URLSession.shared.dataTaskPublisher(for: url)
               .map(\.data)
               .handleEvents(receiveOutput: { data in
                               // Print raw data for debugging purposes
                               if let stringData = String(data: data, encoding: .utf8) {
                                   print("Raw API Response: \(stringData)")
                               }
                           })
               .decode(type: ListOneResponse.self, decoder: JSONDecoder())  // Decode to ListOneResponse struct
               .receive(on: DispatchQueue.main)
               .sink(receiveCompletion: { completion in
                   if case .failure(let error) = completion {
                       print("Error fetching data: \(error)")
                   }
               }, receiveValue: { [weak self] response in
                   // Convert the array of strings to array of doubles
                   let doubleArray: [[Double]] = response.list_one.compactMap { items in
                       // Ensure there are at least 2 items and attempt to convert them to Double
                       guard items.count >= 2, let lat = Double(items[0]), let lon = Double(items[1]) else {
                           return nil  // Skip invalid data
                       }
                       return [lat, lon]
                   }
                   self?.arrayOfInts2 = doubleArray  // Assign the converted array to arrayOfInts
                   // Print the fetched array to the command line
                   print("Fetched array:", doubleArray)
               })
               .store(in: &cancellables)
       }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,span: MapDetails.defaultSpan)
    
    
    
    
    
    
    
    
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            
        }
        else{
            print("Show an alert letting them know they don't have location services enabled")
        }
    }
    // getting the location using the location manager
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted likely due to parental controls")
        case .denied:
            print("You have denied this app location permission. Go into the settings to change it")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span:MapDetails.defaultSpan)
        
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkLocationAuthorization()
    
    }
    
    func updateRegionToUserLocation() {
            if let location = locationManager?.location {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MapDetails.defaultSpan
                )
            }
        }
    
    
    
}
