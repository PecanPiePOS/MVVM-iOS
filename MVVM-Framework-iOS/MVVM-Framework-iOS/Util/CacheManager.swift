//
//  CacheManager.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/21.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
