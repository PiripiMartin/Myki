import Foundation
import SwiftUI
import MapKit

struct PageTwoView: View {
    @State private var selectedOption: String? = nil
    
    var body: some View {
        
        HStack() {
            VStack {
                Text("Welcome to Page Two\n enter your selection")
                
                
                // Correct Menu implementation
                Menu {
                    Button(action: {
                        // First Option action
                        selectedOption = "58 towards city"
                    }) {
                        Text("58 towards city")
                    }
                    Button(action: {
                        // Second Option action
                        selectedOption = "58 away from city"
                    }) {
                        Text("58 away from city")
                    }
                    Button(action: {
                        selectedOption = "96 towards city"
                        // Third Option action
                    }) {
                        Text("96 towards city")
                    }
                }label: {
                    Text("Select your tram")
                }
                
                if let option = selectedOption{
                    Text("You selected: " + option)
                }
                
                
                Button(action: {}){Text("Start Protecting")}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                
                
            
            
        // to the top
            }
            .padding()
            // from the top
            
          // to the left
        }
        .padding()
        // this is padding from the left
        
        
        
    }
}
