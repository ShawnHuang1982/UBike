//
//  StationInMapPageViewController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/11/30.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//
/// reference bottomSheetVC from: https://stackoverflow.com/questions/37967555/how-can-i-mimic-the-bottom-sheet-from-the-maps-app

import UIKit
import MapKit

class StationInMapPageViewController: UIViewController {
    
    let mapView: MKMapView! = MKMapView()
    
    var viewModel: UBikeRentInfoViewModel!
    
    var bottomSheetVCheight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheeView()

    }
    
    private func initView(){
        self.view.backgroundColor = .green
        setMapView()
        moveLocation()
    }
    
    private func addBottomSheeView(){
        //1
        let bottomSheetVC = CardViewController()
        //2
        bottomSheetVC.viewModel = self.viewModel
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetVC.didMove(toParent: self)
        let
        bottomSheetVCheight = bottomSheetVC.view.heightAnchor.constraint(equalToConstant: 400)
        //3
        NSLayoutConstraint.activate([
            bottomSheetVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomSheetVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            bottomSheetVC.view.trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            bottomSheetVCheight
        ])
    }
    
    
    
    private func setMapView(){
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    private func moveLocation(){
        guard viewModel != nil, let latitude = Double("\(viewModel.lat)"), let longitude = Double("\(viewModel.lng)") else {
            return
        }
        
        // 1
           let location = CLLocationCoordinate2D(latitude: latitude,
               longitude: longitude)
           
        debugPrint(latitude, longitude)
        
           // 2
           let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
           let region = MKCoordinateRegion(center: location, span: span)
               mapView.setRegion(region, animated: true)
               
           //3
           let annotation = MKPointAnnotation()
           annotation.coordinate = location
        annotation.title = viewModel.sna
        annotation.subtitle = viewModel.sbi
           mapView.addAnnotation(annotation)
    }
}
