//
//  UIView+.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/09/04.
//

import UIKit

extension UIView {
    
    func scaleView(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scaleView(by: scale)
        }
    }
    
    func saveUIViewWithScale(with scale: CGFloat? = nil) -> Data? {
        let newScale = scale ?? UIScreen.main.scale
        self.scaleView(by: newScale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        let image = renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
        let imageData = image.pngData()
        
        return imageData
    }
}
