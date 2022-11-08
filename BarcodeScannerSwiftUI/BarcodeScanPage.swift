//
//  BarcodeScanPage.swift
//  BarcodeScannerSwiftUI
//
//  Created by Rivaldo Fernandes on 08/11/22.
//

import Foundation
import SwiftUI


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



struct BarcodeScanPage_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanPage()
    }
}


