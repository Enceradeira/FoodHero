//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FHPlacesAPI: NSObject {
    private let _urlBuilder: FHPlacesUrlBuilder
    private let _queue: NSOperationQueue

    public init(baseUrl: String) {
        _urlBuilder = FHPlacesUrlBuilder(baseUrl: baseUrl)
        _queue = NSOperationQueue()
    }

    public func findPlaces(cuisine: String, occasion: String, location: CLLocation) -> AnyObject {
        let cuisineEncoded = cuisine
        let occasionEncoded = occasion
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let urlString = _urlBuilder.buildUrlWithCuisine(cuisine, occasion: occasion, location: location)

        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
        /*let conn = NSURLConnection.sendSynchronousRequest(request, queue: _queue) {
            (response: NSURLResponse!, data: NSData!) in

        } */
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSError?
        var dataVal: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
        if error != nil {
            return error!;
        }
        var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &error)
        if error != nil {
            return error!;
        }

        let jsonArray = jsonResult as! [AnyObject]
        return jsonArray.map {
            (element) -> GooglePlace in
            let values = element as! NSDictionary
            let placeId = values["placeId"] as! String
            let cuisineRelevance = values["cuisineRelevance"] as! Double
            let priceLevel = values["priceLevel"] as! UInt
            let locationValue = values["location"] as! NSDictionary
            let latitude = locationValue["latitude"] as! Double
            let longitude = locationValue["longitude"] as! Double
            let location = CLLocation(latitude: latitude, longitude: longitude)
            return Place(placeId: placeId, location: location, priceLevel: priceLevel, cuisineRelevance: cuisineRelevance)
        }
    }


}
