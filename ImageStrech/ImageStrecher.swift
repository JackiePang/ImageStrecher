//
//  ImageStrecher.swift
//  ImageStrech
//
//  Created by 庞首伟 on 2020/7/30.
//  Copyright © 2020 因未来. All rights reserved.
//

import Foundation
import UIKit

class ImageStrecher {
    
    enum StrechError: Error {
        case strectRectOverlay
    }
    
    
    struct CropRange {
        init(from: CGFloat, length: CGFloat, renderLength: CGFloat) {
            self.from = from
            self.length = length
            self.renderLength = renderLength
        }
        var from: CGFloat = 0
        var length: CGFloat = 0
        var renderLength: CGFloat = 0
        
        
        func slide(strech: StrechRange) -> (lowCrop: CropRange?, strechCrop: CropRange, highCrop: CropRange?) {
            
            let strechCrop = CropRange(from: strech.cropFrom, length: strech.croplength, renderLength: strech.renderLength)
            
            
            // 拉伸区域包含上（前）半部分
            if strech.cropFrom == from {
                let highLength = self.length-strech.croplength
                if highLength == 0 {
                    return (nil, strechCrop ,nil)
                } else {
                    let highCrop = CropRange(from: strech.cropFrom+strech.croplength, length: self.length-strech.croplength, renderLength: self.length-strech.croplength)
                    return (nil, strechCrop ,highCrop)
                }
            } else {
                let lowCrop = CropRange(from: from, length: strech.cropFrom-from, renderLength: strech.cropFrom-from)
                
                            
                if strech.cropFrom+strech.croplength < self.from+self.length {
                    let highCrop = CropRange(from: strech.cropFrom+strech.croplength, length: self.length-strech.croplength-lowCrop.length, renderLength: self.length-strech.croplength-lowCrop.length)
                    return (lowCrop, strechCrop ,highCrop)
                
                    // 拉伸区域包含下半部分
                } else {
                    return (lowCrop, strechCrop ,nil)
                }
            }
        }
    }
    
    struct StrechRange {
        
        var cropFrom: CGFloat = 0
        
        var croplength: CGFloat = 0
        
        var renderLength: CGFloat = 0
    }
    
    
    enum Direction {
        case horizental
        case vertical
    }
    
    func strech(image: UIImage, streches sortedByAscend: [StrechRange], direction: Direction) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        let imageWidth = image.size.width*image.scale
        let imageHeight = image.size.height*image.scale
        
        var renderWidth = imageWidth
        var renderHeight = imageHeight
        let length = direction == .horizental ? imageWidth : imageHeight
        var reminderCrop = CropRange(from: 0, length: length, renderLength: length)
        
        var cropRanges = [CropRange]()
        for (index, strect) in sortedByAscend.enumerated() {
            let slideRanges = reminderCrop.slide(strech: strect)
            if let lowRange = slideRanges.lowCrop {
                cropRanges.append(lowRange)
            }
            
            cropRanges.append(slideRanges.strechCrop)
            
            if let highCrop = slideRanges.highCrop {
                reminderCrop = highCrop
                if index == sortedByAscend.count-1 {
                    cropRanges.append(highCrop)
                }
            }
            
            if direction == .horizental {
                renderWidth += CGFloat(strect.renderLength-strect.croplength)
            } else {
                renderHeight += CGFloat(strect.renderLength-strect.croplength)
            }
        }
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: renderWidth, height: renderHeight), false, 1)
        defer { UIGraphicsEndImageContext() }
        
        var renderStart: CGFloat = 0
        for crop in cropRanges {
            let cropRect = direction == .horizental ? CGRect(x: crop.from, y: 0, width: crop.length, height: imageHeight) : CGRect(x: 0, y: crop.from, width: imageWidth, height: crop.length)
            
            let renderRect = direction == .horizental ? CGRect(x: renderStart, y: 0, width: crop.length, height: imageHeight ) : CGRect(x: 0, y: renderStart, width: imageWidth, height: crop.renderLength)
            
            let cropCGImage = cgImage.cropping(to: cropRect)
            let cropImage = UIImage(cgImage: cropCGImage!)
            cropImage.draw(in: renderRect)
            renderStart += crop.renderLength
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
}
