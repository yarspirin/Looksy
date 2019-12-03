//
//  CameraViewController.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 30/11/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func navigateToPinterest(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "InspirationViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoTouchUpInside(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func photoLibraryButtonTouchUpInside(_ sender: UIButton) {
        guard let photoLibraryController = photoLibraryController else {
            return
        }
        
        present(photoLibraryController, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var currentImage: UIImage?
    var photoLibraryController: UIImagePickerController?
    var cameraPosition: AVCaptureDevice.Position = .back
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession(with: cameraPosition)
        setupPhotoLibraryController()
    }
    
    // MARK: - Setup
    
    private func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                     .builtInMicrophone,
                                                                     .builtInDualCamera,
                                                                     .builtInTelephotoCamera],
                                                       mediaType: AVMediaType.video,
                                                       position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }

        return nil
    }
    
    private func setupSession(with position: AVCaptureDevice.Position) {
        
        guard let captureDevice = captureDevice(with: position) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            guard let capturePhotoOutput = capturePhotoOutput,
                let captureSession = captureSession else {
                return
            }
            
            captureSession.addOutput(capturePhotoOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            previewImageView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    private func setupPhotoLibraryController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            photoLibraryController = UIImagePickerController()
            
            guard let photoLibraryController = photoLibraryController else {
                return
            }
            
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = .photoLibrary
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            currentImage = image
        }
        
        dismiss(animated: true) {
            self.navigateToSegmentation()
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer,
                                                                               previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        currentImage = UIImage.init(data: imageData , scale: 1.0)
        navigateToSegmentation()
    }
}

extension CameraViewController {
    private func navigateToSegmentation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let segmentationVC = storyboard.instantiateViewController(withIdentifier: String(describing: SegmentationViewController.self)) as! SegmentationViewController
        segmentationVC.modalPresentationStyle = .fullScreen
        segmentationVC.lookImage = currentImage
        self.present(segmentationVC, animated: true, completion: nil)
    }
}
