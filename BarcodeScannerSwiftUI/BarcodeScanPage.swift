//
//  BarcodeScanPage.swift
//  BarcodeScannerSwiftUI
//
//  Created by Rivaldo Fernandes on 08/11/22.
//

import Foundation
import SwiftUI
import AVFoundation


struct BarcodeScanPage: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


struct BarcodeScanPageView: UIViewControllerRepresentable {
    @Binding var result: String?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        <#code#>
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        <#code#>
    }
    
    func makeCoordinator() -> () {
        <#code#>
    }
    
}

class BarcodeScanPageViewController: UIViewController {
    override func viewDidLoad() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        captureSession.addInput(input)

        let metadataOutput = AVCaptureMetadataOutput()

        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)

            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        }else{
            return
        }
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        captureSession.startRunning()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
}

extension BarcodeScanPageViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let first = metadataObjects.first {
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = readableObject.stringValue else {
                return
            }

            found(code: stringValue)

        }else{
            print("Not able to read the code! Please try again")
        }
    }

    func found(code: String){
        print(code)
    }
}


struct BarcodeScanPage_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanPage()
    }
}


