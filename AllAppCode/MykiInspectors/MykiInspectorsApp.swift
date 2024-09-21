import SwiftUI
import MapKit

@main
struct HelloWorldApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MapView()
            }
        }
    }
}

struct Point: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}





struct MapView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var locationManager = LocationManager()
    // this array Of ints isnt used
    @State private var arrayOfInts: [[Double]] = [
        [-37.7988214, 144.964355],  // melb uni
        [-37.8083621, 144.9562938],  // Vic market
        [-37.8125509, 144.9627482],  // CBD
           [37.7740, -122.4394],  // North West
           [37.7849, -122.4294],  // South East
           [37.7640, -122.4094],  // Far South East
           [37.7840, -122.4394],  // Far North West
           [37.7649, -122.4194],  // Direct South
           [37.7749, -122.4094],  // Direct East
           [37.7849, -122.4194]   // Direct North
       ]
    private var pointsOfInterest: [Point] {
        viewModel.arrayOfInts2.map { Point(coordinate: CLLocationCoordinate2D(latitude: $0[0], longitude: $0[1])) }
        }
    // this timer is to call the api every 10 seconds
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: pointsOfInterest) { poi in
                MapAnnotation(coordinate: poi.coordinate) {
                    VStack {
                        Image(systemName: "person.3")  // Custom icon using SF Symbols
                            .resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .background(Color.red)   // Background color
                            .clipShape(Circle())     // Circular background
                            .shadow(radius: 6)

                        // Optionally add a label
                        // Text("Inspector")
                        //    .font(.caption)
                        //    .foregroundColor(.black)
                    }
                    .padding(5)
                }
            }
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
                viewModel.fetchCoordinates()
                // Set up the timer to call the api every 10 seconds
               // timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: ///true) { _ in
                   // viewModel.fetchCoordinates()
                   // }
            }

            VStack {
                
                HStack {
                                    // Button to center map on user location
                                    Button(action: {
                                        viewModel.updateRegionToUserLocation()
                                    }) {
                                        Image(systemName: "location.fill")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 6)
                                    }
                                    .padding()
                                    .opacity(0.8)
                    

                                    Spacer()
                                    // Button to center map on user location
                                    Button(action: {
                                    
                                    }) {
                                            Image(systemName: "gearshape.fill")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 6)
                                    }
                                    .padding()
                                    .opacity(0.8)
                    
                    
                    
                                 
                                }
                                .padding()

                
                Spacer()
               
            
                HStack {
                    Button(action: {
                        
                        
                        if let location = viewModel.locationManager?.location {
                                                    let newCoordinate = [location.coordinate.latitude, location.coordinate.longitude]
                                                    arrayOfInts.append(newCoordinate)
                                                    print("New coordinate added:", newCoordinate)
                                                } else {
                                                    print("Location not available")
                                                }

                        
                        
                        print("hello world tapped")
                        // Ensure `createPointsOfInterest` is defined or remove if not needed
                        // createPointsOfInterest(from: arrayOfInts)
                    }) {
                        
                        
                        
                        NavigationLink(destination: PageTwoView()) {
                            Text("Select my tram")
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .padding()
                        }.shadow(radius: 10)
                            .opacity(9)

                        
                        HStack {
                            
                            Text("+")
                                .fontWeight(.bold)
                                .font(.system(size: 25))
    
                            Image(systemName: "person.3")
                                .resizable() // Make the image resizable
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(Color.red)   // Background color
                                .clipShape(Circle())     // Circular background
                                .shadow(radius: 2)
                                //.font(.largeTitle)
                                //.padding(10)
                                //.background(Color.red)
                                //.cornerRadius(100)
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .opacity(0.9)
                    }

                    
                                    }
                .padding()

                
            }
            .padding()
        }
        .onAppear {
            print("hello")
            // Ensure `createPointsOfInterest` is defined or remove if not needed
            // createPointsOfInterest(from: arrayOfInts)
            print("Points of Interest:", pointsOfInterest)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
