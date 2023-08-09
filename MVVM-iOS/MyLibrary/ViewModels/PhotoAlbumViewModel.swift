//
//  PhotoAlbumViewModel.swift
//  MVVM-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/03.
//

import UIKit

import RxSwift
import RxCocoa

public protocol PhotoAlbumViewModelInputs {
    /// Call when the indivisual cell is tapped.
    func photoCellTapped()
    
    /// Call when the images are updated.
    func updatePhotos()
    
    /// Call when the view should be refreshed.
    func refresh()
    
    /// Call when the button that animates cells is tapped.
    func animateCellButtonTapped()
    
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the view will appear with animated property.
    func viewWillAppear(animated: Bool)
}

    // 보통 RxSwift 를 사용해서 쓴다. KickStarter 에서는 ReactiveSwift 의 Signal 을 사용해서 바인딩을 시킨 것 같다.
    // Output 을 조금 더 확실하게 확인하려면, ReactiveSwift 의 Signal 을 조금 더 공부해봐야겠다.
public protocol PhotoAlbumViewModelOutputs {
    
}
    // 여긴 왜 get 만 있을까?
public protocol PhotoAlbumViewModelType {
    var inputs: PhotoAlbumViewModelInputs { get }
    var outputs: PhotoAlbumViewModelOutputs { get }
}

public final class PhotoAlbumViewModel: PhotoAlbumViewModelType, PhotoAlbumViewModelInputs, PhotoAlbumViewModelOutputs {
    
    /// 어떤 이유로..? 왜 self 를 리턴하지?
    /// => 그 이유는, 해당 VM 에서 사용된 각자의 Protocol 에서 정의된 func 만 떼어내 사용할 수 있다.
    public var inputs: PhotoAlbumViewModelInputs { return self }
    public var outputs: PhotoAlbumViewModelOutputs { return self }
    
    public func photoCellTapped() {
        
    }
    
    public func updatePhotos() {
        
    }
    
    public func refresh() {
        
    }
    
    public func animateCellButtonTapped() {
        
    }
    
    public func viewDidLoad() {
        
    }
    
    public func viewWillAppear(animated: Bool) {
        
    }
}
