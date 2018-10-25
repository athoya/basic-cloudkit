//
//  UploadStoryViewController.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 19/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MapKit

class UploadStoryViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var videoUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openCamera() {
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindSegue" {
            if let cameraController = segue.source as? CameraController {
                guard let url = cameraController.outputURL else {return}
                self.videoUrl = url
                assignThumbnail(url: url)
            }
        }
    }
    
    func assignThumbnail(url: URL) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let frameImage  = UIImage(cgImage: img!)
                DispatchQueue.main.async(execute: {
                    // assign your image to UIImageView
                    self.thumbnail.image = frameImage
                    self.recordButton.isHidden = true
                })
            }
        }
    }
    
    @IBAction func imageViewDidTap(_ sender: UITapGestureRecognizer) {
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        guard let myUrl = videoUrl else {return}
        let player = AVPlayer(url: myUrl)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
        
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveDidTap(){
        self.recordButton.isHidden = false
        self.tabBarController?.selectedIndex = 0
        addToMapViewAndShowAnnotation()
    }
    
    func addToMapViewAndShowAnnotation(){
        if let controllers = self.tabBarController?.viewControllers, let navController = controllers[0] as? UINavigationController,
            let storyMapVC = navController.viewControllers[0] as? StoriesMapViewController {
            let (lat, lon) = NumberHelper().getRandomLatLong()
            let dummyCoordinate = CLLocationCoordinate2DMake(lat, lon)
            let story = Story(title: "Morning",coordinate: dummyCoordinate, thumbnail: #imageLiteral(resourceName: "beautiful_morning"))
            storyMapVC.createAnnotation(story: story)
            CloudKitHelper().createNewRecordByStory(story: story)
        }
    }
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//
//    }
    

}
