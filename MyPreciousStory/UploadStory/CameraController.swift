//
//  CameraController.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 22/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    @IBOutlet weak var cameraPreview: UIView!
    
    var recordButton: UIButton = UIButton()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var cameraHelper: CameraHelper?
    
    var outputURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cameraHelper = CameraHelper(outputDelegate: self)
        guard let cameraHelper = cameraHelper else {return}
        if cameraHelper.setupSession() {
            // Configure previewLayer
            guard let captureSession = cameraHelper.captureSession else {return}
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = cameraPreview.bounds
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreview.layer.addSublayer(previewLayer)
            cameraHelper.startSession()
        }
        
        
        let x = view.frame.width / 2 - 50
        let y = view.frame.height - 200
        recordButton.frame = CGRect(x: x, y: y, width: 100, height: 100)
        recordButton.backgroundColor = .white
        recordButton.layer.cornerRadius = 50
        recordButton.layer.masksToBounds = true
        let recordButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(recordButtonDidTap))
        recordButton.addGestureRecognizer(recordButtonRecognizer)
        view.addSubview(recordButton)
        
    }
    
    @objc func recordButtonDidTap(){
        if recordButton.backgroundColor == .white {
            cameraHelper?.startRecording()
            recordButton.backgroundColor = .red
        }else{
            cameraHelper?.stopRecording()
            recordButton.backgroundColor = .white
        }
    }
    
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            outputURL = outputFileURL
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
}
