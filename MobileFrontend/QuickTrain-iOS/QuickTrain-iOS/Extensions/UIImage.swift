//
//  UIImage.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import UIKit

extension UIImage {

    private enum BlendMode {
        case multiply // This results in colors that are at least as dark as either of the two contributing sample colors
        case screen // This results in colors that are at least as light as either of the two contributing sample colors

    }

    // A level of zero yeilds the original image, a level of 1 results in black
    func darken(level: CGFloat = 0.5) -> UIImage? {
        return blend(mode: .multiply, level: level)
    }

    // A level of zero yeilds the original image, a level of 1 results in white
    func lighten(level: CGFloat = 0.5) -> UIImage? {
        return blend(mode: .screen, level: level)
    }

    private func blend(mode: BlendMode, level: CGFloat) -> UIImage? {
        let context = CIContext(options: nil)

        var level = level
        if level < 0 { level = 0 }
        else if level > 1 { level = 1 }

        let filterName: String
        switch mode {
        case .multiply: // As the level increases we get less white
            level = abs(level - 1.0)
            filterName = "CIMultiplyBlendMode"
        case .screen: // As the level increases we get more white
            filterName = "CIScreenBlendMode"
        }

        let blender = CIFilter(name: filterName)!
        let backgroundColor = CIColor(color: UIColor(white: level, alpha: 1))

        guard let inputImage = CIImage(image: self) else { return nil }
        blender.setValue(inputImage, forKey: kCIInputImageKey)

        guard let backgroundImageGenerator = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        backgroundImageGenerator.setValue(backgroundColor, forKey: kCIInputColorKey)
        guard let backgroundImage = backgroundImageGenerator.outputImage?.cropped(to: CGRect(origin: CGPoint.zero, size: self.size)) else { return nil }
        blender.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)

        guard let blendedImage = blender.outputImage else { return nil }

        guard let cgImage = context.createCGImage(blendedImage, from: blendedImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
