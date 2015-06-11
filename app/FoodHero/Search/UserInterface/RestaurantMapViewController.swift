//
// Created by Jorg on 08/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantMapViewController: UIViewController, GMSMapViewDelegate {
    var _restaurant: Restaurant!
    var _locationService: LocationService!

    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var directions: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var directionsView: UIView!
    func setRestaurant(restaurant: Restaurant) {
        _restaurant = restaurant;
    }

    func setLocationService(locationService: LocationService) {
        _locationService = locationService
    }

    override func viewDidAppear(animated: Bool) {
        GAIService.logScreenViewed("Restaurant Map")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        var subView: GMSMapView = GMSMapView.mapWithFrame(mapView.frame, camera: camera);
        subView.myLocationEnabled = true
        subView.settings.myLocationButton = true;
        subView.settings.compassButton = true;
        subView.delegate = self

        // Marker
        let marker = GMSMarker()
        marker.position = restaurantCoordinate
        marker.snippet = _restaurant.name // or title
        marker.icon = GMSMarker.markerImageWithColor(FoodHeroColors.actionColor())
        marker.map = subView
        subView.selectedMarker = marker

        // Add Map View
        subView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.addSubview(subView)
        let subViews = ["subView": subView]
        mapView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0.0-[subView]-0.0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: subViews))
        mapView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0.0-[subView]-0.0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: subViews))

        //  map
        var tapGesture = UITapGestureRecognizer(target: self, action: "userDidTapDirections")
        directions.addGestureRecognizer(tapGesture)
        directions.userInteractionEnabled = true

        // map button
        directionsButton.imageView!.highlightedImage = UIImage(named: "directions-icon-transparent@2x.png");
    }

    @IBAction func directionsTouched(sender: AnyObject) {
        userDidTapDirections()
    }

    func userDidTapDirections() {
        let myCoordinate = _locationService.lastKnownLocation().coordinate
        let restaurantCoordinate = _restaurant.location.coordinate

        /*
        let encodedComponents = _restaurant.addressComponents.map {
            (component: AnyObject!) in
            return KeywordEncoder.encodeString(component as! String) as String
        }
        let restaurantAddressEncoded = ",".join(encodedComponents)
         */
        // let url = "https://www.google.com/maps/dir/\(coordinate.latitude),\(coordinate.longitude)/\(restaurantAddressEncoded)"
        let url = "https://www.google.com/maps/dir/\(myCoordinate.latitude),\(myCoordinate.longitude)/\(restaurantCoordinate.latitude),\(restaurantCoordinate.longitude)"
        let webUrl = NSURL(string: url)!
        UIApplication.sharedApplication().openURL(webUrl)
        GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageRestaurantMapInput(), label: "directions", value: 0)
    }

}
