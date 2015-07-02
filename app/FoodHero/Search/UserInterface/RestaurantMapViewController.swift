//
// Created by Jorg on 08/05/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantMapViewController: UIViewController, GMSMapViewDelegate {
    private var _restaurant: Restaurant!
    private var _locationService: LocationService!
    private var _gmsMapView: GMSMapView!

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

    private func createCameraPosition(myLocation: CLLocation) -> GMSCameraPosition {
        let myCoordinate = myLocation.coordinate
        let restaurantLocation = _restaurant.location;
        let restaurantCoordinate = restaurantLocation.coordinate

        let midpoint = CLLocation(latitude: (myCoordinate.latitude + restaurantCoordinate.latitude) / 2,
                longitude: (myCoordinate.longitude + restaurantCoordinate.longitude) / 2).coordinate
        let distance = restaurantLocation.distanceFromLocation(myLocation)

        let zoom = GMSCameraPosition.zoomAtCoordinate(midpoint, forMeters: distance / 0.6, perPoints: view.bounds.size.width)
        return GMSCameraPosition.cameraWithLatitude(midpoint.latitude, longitude: midpoint.longitude, zoom: zoom);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let myLocation = _restaurant.distance.searchLocation
        let myCoordinate = myLocation.coordinate
        let restaurantLocation = _restaurant.location;
        let restaurantCoordinate = restaurantLocation.coordinate

        let midpoint = CLLocation(latitude: (myCoordinate.latitude + restaurantCoordinate.latitude) / 2,
                longitude: (myCoordinate.longitude + restaurantCoordinate.longitude) / 2).coordinate
        let distance = restaurantLocation.distanceFromLocation(myLocation)

        let zoom = GMSCameraPosition.zoomAtCoordinate(midpoint, forMeters: distance / 0.6, perPoints: view.bounds.size.width)
        let camera = createCameraPosition(myLocation)

        // Map
        _gmsMapView = GMSMapView.mapWithFrame(mapView.frame, camera: camera);
        _gmsMapView.myLocationEnabled = true
        _gmsMapView.settings.myLocationButton = true;
        _gmsMapView.settings.compassButton = true;
        _gmsMapView.delegate = self

        if _restaurant.distance.hasPreferredSearchLocation {
            // Marker for preferred Search Location (which is not current location)
            let preferredLocationMarker = GMSMarker()
            preferredLocationMarker.position = _restaurant.distance.searchLocation.coordinate
            preferredLocationMarker.title = _restaurant.distance.searchLocationDescription
            preferredLocationMarker.icon = GMSMarker.markerImageWithColor(FoodHeroColors.yellowColor())
            preferredLocationMarker.map = _gmsMapView
        }

        // Marker for Restaurant
        let restaurantMarker = GMSMarker()
        restaurantMarker.position = restaurantCoordinate
        restaurantMarker.title = _restaurant.name // or title
        restaurantMarker.icon = GMSMarker.markerImageWithColor(FoodHeroColors.actionColor())
        restaurantMarker.map = _gmsMapView
        _gmsMapView.selectedMarker = restaurantMarker

        // Add Map View
        _gmsMapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.addSubview(_gmsMapView)
        let subViews = ["subView": _gmsMapView]
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

    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        _gmsMapView.animateToCameraPosition(createCameraPosition(_gmsMapView.myLocation))
        return true
    }
}
