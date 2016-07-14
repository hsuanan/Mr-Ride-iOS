//
//  TrackingManager.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 7/14/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import Foundation
import Amplitude_iOS

class TrackingManager{
    
    static let sharedManager = TrackingManager()
    
    func createEventTracking(category: String, action: String){
        GAEventTracking(category: category, action: action)
        amplitudeLogEvent(event: action)
    }
    
    func createScreenTracking(viewName: String){
        GAScreenTracking(view: viewName)
        amplitudeLogEvent(event: viewName)
        
    }
}


//MARK: Google Analytics
extension TrackingManager{
    
    private func GAEventTracking(category category: String, action: String){
        let tracker = GAI.sharedInstance().defaultTracker
        let eventTracker: NSObject = GAIDictionaryBuilder.createEventWithCategory(
            category,
            action: action,
            label: "",
            value: nil).build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
    }
    
    private func GAScreenTracking(view viewname: String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: viewname)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
}


//MARK: Amplitude
extension TrackingManager{
    private func amplitudeLogEvent(event event: String){
        Amplitude.instance().logEvent(event)
    }
    
    
}