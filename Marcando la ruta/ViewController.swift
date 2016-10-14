//
//  ViewController.swift
//  Marcando la ruta
//
//  Created by Administrador on 13/10/16.
//  Copyright © 2016 ITESO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private var manejador = CLLocationManager()
    
    var startLocation : CLLocation!
    var lastLocation : CLLocation!
    var traveledDistance : Double = 0
    
    var cincuentaMetros : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
    }
    
    //Los tres botones para cambiar el tipo de mapa
    @IBAction func normalMapa(_ sender: AnyObject) {
        self.mapa.mapType = .standard
    }

    @IBAction func sateliteMapa(_ sender: AnyObject) {
        self.mapa.mapType = .satelliteFlyover
    }
    
    @IBAction func hibridoMapa(_ sender: AnyObject) {
        self.mapa.mapType = .hybridFlyover
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latitude:CLLocationDegrees = (manejador.location?.coordinate.latitude)!
        
        let longitude:CLLocationDegrees = (manejador.location?.coordinate.longitude)!
        
        let latDelta:CLLocationDegrees = 0.01       //zoom
        
        let lonDelta:CLLocationDegrees = 0.01       //zoom
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapa.setRegion(region, animated: false)
        manejador.startUpdatingLocation()
        
        
        if startLocation == nil {
            startLocation = locations.first
        } else {
            if let lastLocation = locations.last {
                
                //obteniendo la distancia entre puntos
                let distance = startLocation.distance(from: lastLocation)
                let lastLocation = locations.last
                traveledDistance += distance
                cincuentaMetros += distance
//                print( "\(startLocation)")
//                print( "\(lastLocation)")
                print("FULL DISTANCE: \(traveledDistance)")
                print("STRAIGHT DISTANCE: \(distance)")
                startLocation = lastLocation
                
                //calculando un aproximado de 50 metros
                if (cincuentaMetros - 0) >= 50 {
                    print("Han pasado 50 metros")
                    cincuentaMetros = 0
                    
                    //dibujando cuando recorra 50 metros o más
                    let pin = MKPointAnnotation()
                    pin.title = "Lat: \(latitude), Lon \(longitude)"
                    pin.subtitle = "Distancia: \(traveledDistance)"
                    pin.coordinate = location
                    
                    mapa.addAnnotation(pin)
                }
                
                
            }
        }
        
        lastLocation = locations.last
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
        
    }
    

}

