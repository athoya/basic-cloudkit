//
//  StoriesMapViewController.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 19/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import UIKit
import MapKit

class StoriesMapViewController: UIViewController {

    @IBOutlet weak var storiesMapView: MKMapView!
    
    var storiesMap: StoriesMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -6.2960874, longitude: 106.6415353), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        storiesMapView.setRegion(region, animated: true)
        
        storiesMapView.delegate = self
        
        CloudKitHelper().fetchStoryRecord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        storiesMap = StoriesMap()
        guard let storiesMap = storiesMap else {return}
        for story in storiesMap.dummyStories {
            let beautifulMorningAnnotation = StoriesAnnotation(coordinate: story.coordinate)
            beautifulMorningAnnotation.titleVideo = story.title
            beautifulMorningAnnotation.thumbnailVideo = story.thumbnail
            
            storiesMapView.addAnnotation(beautifulMorningAnnotation)
        }
    }
    
    func createAnnotation(story: Story) {
        storiesMap?.addDummyStories(story: story)
        let newAnnotation = StoriesAnnotation(coordinate: story.coordinate)
        newAnnotation.titleVideo = story.title
        newAnnotation.thumbnailVideo = story.thumbnail
        
        storiesMapView.addAnnotation(newAnnotation)
        storiesMapView.setCenter(newAnnotation.coordinate, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- MKMapKitDelegate
extension StoriesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if the annotation is the user location, we dont need to show the annotation
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = storiesMapView.dequeueReusableAnnotationView(withIdentifier: "story")
        if annotationView == nil {
            annotationView = StoriesAnnotationView(annotation: annotation, reuseIdentifier: "story")
            annotationView?.canShowCallout = false
        }else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = #imageLiteral(resourceName: "pin_location")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        
        guard let story = view.annotation as? StoriesAnnotation else {return}
        let popUpViews = Bundle.main.loadNibNamed("PopUp", owner: nil, options: nil)
        guard let popUpView = popUpViews?.first as? PopUpView else {return}
        popUpView.titleLabel.text = story.titleVideo
        popUpView.thumbnailImageView.image = story.thumbnailVideo
        
        popUpView.center = CGPoint(x: view.bounds.size.width / 2, y: -popUpView.bounds.size.height*0.52)
        view.addSubview(popUpView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: StoriesAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
}
