//
//  UICollectionViewCell+.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/31.
//

import UIKit

extension UICollectionViewCell {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

