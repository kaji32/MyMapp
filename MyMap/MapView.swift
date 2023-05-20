//
//  MapView.swift
//  MyMap
//
//  Created by 中嶋真太郎 on 2023/05/20.
//

import SwiftUI
import MapKit

enum MapType{
    case standard
    case satellite
    case hybrid
}

struct MapView: UIViewRepresentable {
    let searchKey: String
    
    let mapType :MapType
    
    func makeUIView(context:Context) -> MKMapView{
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context){
        print("検索キーワード:\(searchKey)")
        
        switch mapType {
        case .standard:
            uiView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        case .satellite:
            uiView.preferredConfiguration = MKImageryMapConfiguration()
        case .hybrid:
            uiView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .flat)
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(
            searchKey,
            completionHandler:{ (placemarks,error) in
                if let placemarks,
                        let firstPlacemark = placemarks.first,
                            let location = firstPlacemark.location{
                                let targetCoordinate = location.coordinate
                
                                print("緯度軽度:\(targetCoordinate)")
                    
                                let pin = MKPointAnnotation()
                                pin.coordinate = targetCoordinate
                                    
                                pin.title = searchKey
                                uiView.addAnnotation(pin)
                                
                                uiView.region = MKCoordinateRegion(
                                    center: targetCoordinate,
                                    latitudinalMeters: 1000.0,
                                    longitudinalMeters: 1000.0
                                )
                    
                    
                }
                    
            }
            
        )
        
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(searchKey: "羽田空港")
//    }
//}
