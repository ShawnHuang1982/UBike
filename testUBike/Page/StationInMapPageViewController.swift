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
            self.listViewModel?.forEach({ [unowned self] (viewModel) in
                makeAnnotaion(mapView: self.mapView, location: viewModel.staLocation?.coordinate, title: viewModel.sna, subTitle: viewModel.ar)
            })
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
        moveToSelectLocation()
    }
    
    private func makeSpecificAnnotation(){
        makeAnnotaion(mapView: self.mapView, location: singleStationViewModel.staLocation?.coordinate, title:  singleStationViewModel.sna , subTitle: singleStationViewModel.sbi )

    }
    
    private func moveToSelectLocation(){
        //move to select location
        // 1
        guard singleStationViewModel != nil, let latitude = Double("\(singleStationViewModel.lat)"), let longitude = Double("\(singleStationViewModel.lng)") else {
            //move to user location
            if userlocation != nil, let location = userlocation?.coordinate{
                moveLocation(location: location)
            }else{
                //default region
                let defaultLoc = CLLocationCoordinate2D(latitude: 25.034255, longitude: 121.562781)
                moveLocation(location: defaultLoc)
            }
            return
        }
        let location = CLLocationCoordinate2D(latitude: latitude,
                                              longitude: longitude)
        moveLocation(location: location)
    }
    
    private func initView(){
        self.view.backgroundColor = UIColor.rgba(23, 28, 27, 1)
        
        setMapView()
        addBottomSheeView()
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
        bottomSheetVC.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectivel
        bottomSheetVC.view.layer.cornerRadius = 10
        bottomSheetVC.view.clipsToBounds = true
        bottomSheetVC.selectMode(mode: .fixedHeight(.list))
        bottomSheetVCheight = bottomSheetVC.view.heightAnchor.constraint(equalToConstant: 380)
        
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
        
        mapView.delegate = self
        
    }
    
    private func makeAnnotaion(mapView: MKMapView, location: CLLocationCoordinate2D?, title:String?, subTitle: String?){
        guard let loc = location else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }
        
    private func moveLocation(location: CLLocationCoordinate2D?){
        guard let loc = location else { return }
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: loc, span: span)
        mapView.setRegion(region, animated: true)
        // Adjust padding here
        let rect = MKMapRectForCoordinateRegion(region: region)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
    }
    
    // Convert CoordinateRegion to MapRect
    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
}

extension StationInMapPageViewController: CardViewControllerDelegate{
    
    func panGesture(offsetY: CGFloat) {
        let newHeight = bottomSheetVCheight.constant - offsetY
        debugPrint(newHeight)
        UIView.animate(withDuration: 0.1) {
            if CardMode.scrollable(.card).contentHeight < newHeight && newHeight < CardMode.fixedHeight(.list).contentHeight{
                self.bottomSheetVCheight.constant = newHeight
            }else if newHeight < CardMode.scrollable(.card).contentHeight {
                self.bottomSheetVCheight.constant = CardMode.scrollable(.card).contentHeight
            }else if newHeight > CardMode.fixedHeight(.list).contentHeight{
                self.bottomSheetVCheight.constant = CardMode.fixedHeight(.list).contentHeight
            }
            self.view.layoutIfNeeded()
        }

    }
    
    func selectedStation(station: UBikeRentInfoViewModel) {
        guard let loc = station.staLocation else {
            return
        }
        moveLocation(location: loc.coordinate)
        
        //select annotation
        let ano = mapView.annotations.filter { (annotation) -> Bool in
            return (annotation.coordinate.latitude == loc.coordinate.latitude) && (annotation.coordinate.longitude == loc.coordinate.longitude)
        }.first
        guard let _ano = ano else { return }
        mapView.selectAnnotation(_ano, animated: true)
        bottomSheetVC.selectMode(mode: .scrollable(.card))
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.bottomSheetVCheight.constant = CardMode.scrollable(.card).contentHeight
        }
    }
}

extension StationInMapPageViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        bottomSheetVC.selectMode(mode: .scrollable(.card))
        let viewModel = listViewModel?.filter{$0.sna == (view.annotation?.title ?? "")}.first
        bottomSheetVC.singleStationViewModel = viewModel
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.bottomSheetVCheight.constant = CardMode.scrollable(.card).contentHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        bottomSheetVC.selectMode(mode: .fixedHeight(.list))
        bottomSheetVC.listViewModel = listViewModel
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.bottomSheetVCheight.constant = CardMode.fixedHeight(.list).contentHeight
            self.view.layoutIfNeeded()
        }
    }
}
