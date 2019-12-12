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
    
    var userlocation: CLLocation?
    var singleStationViewModel: UBikeRentInfoViewModel!
    var listViewModel: [UBikeRentInfoViewModel]?{
        didSet{
            bottomSheetVC.listViewModel = self.listViewModel
        }
    }
    
    lazy var bottomSheetVC = CardViewController()
    private var bottomSheetVCheight: NSLayoutConstraint!
    private var mapViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    private func initView(){
        self.view.backgroundColor = UIColor.rgba(23, 28, 27, 1)
        
        setMapView()
        addBottomSheeView()
        
        
        //move to select location
        // 1
        guard singleStationViewModel != nil, let latitude = Double("\(singleStationViewModel.lat)"), let longitude = Double("\(singleStationViewModel.lng)") else {
            //move to user
            if userlocation != nil, let location = userlocation?.coordinate{
                moveLocation(location: location, title: "", subTitle: "")
            }
            return
        }
        let location = CLLocationCoordinate2D(latitude: latitude,
                                              longitude: longitude)
        moveLocation(location: location, title: singleStationViewModel.sna ?? "", subTitle: singleStationViewModel.sbi ?? "")
    }
    
    private func addGesture(){
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
//           view.addGestureRecognizer(gesture)

    }
    
    private func addBottomSheeView(){
        bottomSheetVC.delegate = self
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetVC.didMove(toParent: self)
        bottomSheetVC.view.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        bottomSheetVC.view.clipsToBounds = true
        bottomSheetVCheight = bottomSheetVC.view.heightAnchor.constraint(equalToConstant: 300)
        
        //3
        NSLayoutConstraint.activate([
            bottomSheetVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomSheetVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            bottomSheetVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            bottomSheetVCheight
        ])
    }
    
    private func setMapView(){
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        mapViewBottom = mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        mapViewBottom.isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
        
    private func moveLocation(location: CLLocationCoordinate2D?, title: String, subTitle: String){
        guard let loc = location else { return }
        debugPrint(location)
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: loc, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }
}

extension StationInMapPageViewController: CardViewControllerDelegate{
    func selectedStation(station: UBikeRentInfoViewModel) {
        guard let lat = CLLocationDegrees(station.lat), let lng = CLLocationDegrees(station.lng) else {
            return
        }
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        moveLocation(location: loc, title: station.sareaen, subTitle: station.ar)
    }
}
