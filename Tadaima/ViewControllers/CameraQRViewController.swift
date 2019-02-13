//
//  CameraQRViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/10/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import AVFoundation

class CameraQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let input: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = CGRect(x: 0, y: 55.0, width: self.view.frame.size.width, height: self.view.frame.size.height - 255)
            view.layer.addSublayer(videoPreviewLayer!)
            
            let descTxt = UITextView()
            descTxt.text = NSLocalizedString("children_scan_description_text", comment: "")
            descTxt.frame = CGRect(x: (self.view.frame.size.width-300)/2.0, y: self.view.frame.size.height-180, width: 300.0, height: 40.0)
            self.automaticallyAdjustsScrollViewInsets = false
            descTxt.font = UIFont.init(name: "Helvetica Neue", size: 17.0)
            descTxt.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            descTxt.textAlignment = NSTextAlignment.center
            descTxt.textColor = UIColor.white
            self.view.addSubview(descTxt)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
            captureSession.startRunning()
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let qrCode = metadataObj.stringValue
                if (qrCode?.isValidQRCode())! {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    captureSession.stopRunning()
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "ConfirmQR") as? ConfirmQRViewController
                    vc?.qrCode = qrCode
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
}
