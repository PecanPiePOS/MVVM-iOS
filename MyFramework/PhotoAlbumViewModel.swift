//
//  PhotoAlbumViewModel.swift
//  MyFramework
//
//  Created by KYUBO A. SHIM on 2023/08/11.
//

import UIKit

import RxSwift
import RxRelay

public protocol PhotoAlbumViewModelInputs {
    /// Call when the indivisual cell is tapped.
    func photoCellTapped()

        /// Call when the images are updated.
    func updatePhotos()
    
    /// Call when the view should be refreshed.
    func refresh()
    
    /// Call when the button that animates cells is tapped.
    func animateCellButtonDoubleTapped()
    
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the view will appear with animated property.
    func viewWillAppear(animated: Bool)
}

public protocol PhotoAlbumViewModelOutputs {
    // OUTPUTS using RxSwifts
}

public protocol PhotoAlbumViewModelType {
    var inputs: PhotoAlbumViewModelInputs { get }
    var outputs: PhotoAlbumViewModelOutputs { get }
}

public final class PhotoAlbumViewModel: PhotoAlbumViewModelType, PhotoAlbumViewModelInputs, PhotoAlbumViewModelOutputs {
    
    
    public var inputs: PhotoAlbumViewModelInputs { return self }
    public var outputs: PhotoAlbumViewModelOutputs { return self }
    
    public func photoCellTapped() {}
    
    public func updatePhotos() {}
    
    public func refresh() {}
    
    public func animateCellButtonDoubleTapped() {}
    
    public func viewDidLoad() {}
    
    public func viewWillAppear(animated: Bool) {}
}
