//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    
    //TODO: Add Capture Session
    lazy var captureSession = AVCaptureSession()
    
    
    //TODO: Add Movie Output
    lazy private var fileOutput = AVCaptureMovieFileOutput()

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Resize camera preview to fill the entire screen
		cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    private func setUpCaptureSession(){
        let camera = bestCamera()
        
        //open
        captureSession.beginConfiguration()
        
        //Add inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else { fatalError("Cant create camera with current input") }
        
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080 //1080p
        }
        
        
        //TODO: Add Microphone
        
        
        //TODO: Add Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot save movie to capture session")
        }
        captureSession.addOutput(fileOutput)
        
        
        
        //close
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
    }
    
    private func bestCamera() -> AVCaptureDevice {

        // ultra wide lens 0.5
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        
        // wide angle lens (available on all iphones)
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        
        //Fatal Error if none of these exist
        fatalError("No cameras on device ")
        
        
    }
    

    @IBAction func recordButtonPressed(_ sender: Any) {
        

	}
	
	/// Creates a new file URL in the documents directory
	private func newRecordingURL() -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]

		let name = formatter.string(from: Date())
		let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
		return fileURL
	}
}

