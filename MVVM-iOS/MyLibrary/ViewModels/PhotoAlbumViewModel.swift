//
//  PhotoAlbumViewModel.swift
//  MVVM-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/03.
//

import UIKit

public protocol PhotoAlbumViewModelInputs {
    /// Call when the indivisual cell is tapped.
    func photoCellTapped()
    
    /// Call when the images are updated.
    func photosUpdated()
    
    /// Call when the view should be refreshed.
    func refresh()
    
    /// Call when the button that animates cells is tapped.
    func animateCellButtonTapped()
    
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the view will appear with animated property.
    func viewWillAppear(animated: Bool)
}

public protocol PhotoAlbumViewModelOutputs {
    
}

public protocol PhotoAlbumViewModelType {
    
}

public final class PhotoAlbumViewModel: PhotoAlbumViewModelType, PhotoAlbumViewModelInputs, PhotoAlbumViewModelOutputs {
    
}
