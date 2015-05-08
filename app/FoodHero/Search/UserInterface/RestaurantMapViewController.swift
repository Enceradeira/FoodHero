//
// Created by Jorg on 08/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantMapViewController: UIViewController, GMSMapViewDelegate {
    var _restaurant: Restaurant!

    func setRestaurant(restaurant: Restaurant) {
        _restaurant = restaurant;
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       //automaticallyAdjustsScrollViewInsets = false;

        let coordinate = _restaurant.location.coordinate
        let camera =  GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 14);
        var gmaps: GMSMapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera);

        gmaps.myLocationEnabled = true
        gmaps.delegate = self

        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = _restaurant.name
        marker.icon = GMSMarker.markerImageWithColor(FoodHeroColors.actionColor())
        marker.map = gmaps

        gmaps.settings.myLocationButton = true;
        gmaps.settings.compassButton = true;

        self.view=gmaps

    }


}
