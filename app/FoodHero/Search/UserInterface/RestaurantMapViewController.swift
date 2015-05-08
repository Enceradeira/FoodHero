//
// Created by Jorg on 08/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantMapViewController: UIViewController, GMSMapViewDelegate {
    var _restaurant: Restaurant!
    var _locationService: LocationService!

    func setRestaurant(restaurant: Restaurant) {
        _restaurant = restaurant;
    }

    func setLocationService(locationService: LocationService) {
        _locationService = locationService
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //automaticallyAdjustsScrollViewInsets = false;

        let myLocation = _locationService.lastKnownLocation()
        let myCoordinate = myLocation.coordinate
        let restaurantLocation = _restaurant.location;
        let restaurantCoordinate = restaurantLocation.coordinate

        let midpoint = CLLocation(latitude: (myCoordinate.latitude + restaurantCoordinate.latitude) / 2,
                longitude: (myCoordinate.longitude + restaurantCoordinate.longitude) / 2).coordinate
        let distance = restaurantLocation.distanceFromLocation(myLocation)

        let zoom = GMSCameraPosition.zoomAtCoordinate(midpoint, forMeters: distance / 0.6, perPoints: view.bounds.size.width)
        let camera = GMSCameraPosition.cameraWithLatitude(midpoint.latitude, longitude: midpoint.longitude, zoom: zoom);

        // Map
        var mapView: GMSMapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera);
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true;
        mapView.settings.compassButton = true;
        mapView.delegate = self

        // Marker
        let marker = GMSMarker()
        marker.position = restaurantCoordinate
        marker.snippet = _restaurant.name // or title
        marker.icon = GMSMarker.markerImageWithColor(FoodHeroColors.actionColor())
        marker.map = mapView
        mapView.selectedMarker = marker

        self.view = mapView

    }


}
