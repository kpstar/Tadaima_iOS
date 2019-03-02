//
//  QRCodeGenerator.swift
//  Tadaima
//
//  Created by KpStar on 2/24/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import Foundation
import UIKit


class QRCodeGenerator {
    
    class func generateQRCodeFromString(_ strQR:String) -> CIImage {
        let dataString = strQR.data(using: String.Encoding.isoLatin1)
        
        let qrFilter = CIFilter(name:"CIQRCodeGenerator")
        qrFilter?.setValue(dataString, forKey: "inputMessage")
        return (qrFilter?.outputImage)!
    }
    
    
    
    class func convert(_ cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
}
