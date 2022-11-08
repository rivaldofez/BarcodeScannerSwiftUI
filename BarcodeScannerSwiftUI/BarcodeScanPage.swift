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
    @State var result: String? = ""
    
    var body: some View {
        ZStack{
            BarcodeScanPageView(result: $result)
            Text(result ?? "Not Detected")
            
        }
        
    }
}

protocol CustomDelegate {
    func didUpdateBarcodeResult(_ value: String?)
}


struct BarcodeScanPageView: UIViewControllerRepresentable {
 
    @Binding var result: String?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = BarcodeScanPageViewController()
        vc.customDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(customView: self)
    }
    
    class Coordinator: NSObject, CustomDelegate {
        var parent: BarcodeScanPageView
        
        init(customView: BarcodeScanPageView){
            self.parent = customView
        }
        
        func didUpdateBarcodeResult(_ value: String?) {
            parent.result = value
        }
    }
    
}

class BarcodeScanPageViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var customDelegate: CustomDelegate?
    
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let first = metadataObjects.first {
           guard let readableObject = first as? AVMetadataMachineReadableCodeObject else {
               return
           }
           guard let stringValue = readableObject.stringValue else {
               return
           }

            self.bindDataBarcode(result: stringValue)

       }else{
           print("Not able to read the code! Please try again")
       }
    }
    
    func bindDataBarcode(result: String?){
        customDelegate?.didUpdateBarcodeResult(result)
    }
    
}


struct BarcodeScanPage_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanPage()
    }
}


