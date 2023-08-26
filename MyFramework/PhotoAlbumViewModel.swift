//
//  PhotoAlbumViewModel.swift
//  MyFramework
//
//  Created by KYUBO A. SHIM on 2023/08/11.
//

import UIKit

import RxSwift
import RxCocoa

/// 이게 POP 구나.
/// https://linux-studying.tistory.com/28

public protocol PhotoAlbumViewModelInputs {

    /// Call when the images are updated.
    func updatePhotos(index: Int)
    
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
    /// This will turn into [PhotoModel] as soon as I get Exif Datas
    /// var photoAlbumLists: BehaviorSubject<[PhotoModel]> { get }

    var photoAlbumLists: BehaviorRelay<[String]> { get }
    
}

public protocol PhotoAlbumViewModelType {
    var inputs: PhotoAlbumViewModelInputs { get }
    var outputs: PhotoAlbumViewModelOutputs { get }
}

public final class PhotoAlbumViewModel: PhotoAlbumViewModelType, PhotoAlbumViewModelInputs, PhotoAlbumViewModelOutputs {
    
    private let imageNumberArray: [Int] = [2567, 3975, 4004, 4199, 4335, 5275, 5400, 5731, 5774, 5905, 6035, 6041]
    private var registeredImageNumberArray: [Int] = []
    private var remainingImageNumberArray: [Int] = []
    
    public let photoAlbumLists: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    public var inputs: PhotoAlbumViewModelInputs { return self }
    public var outputs: PhotoAlbumViewModelOutputs { return self }
    
    public init() {
        let randomPhoto = selectRandomImageName(from: imageNumberArray,
                                                count: 4,
                                                remaining: remainingImageNumberArray,
                                                registered: registeredImageNumberArray)
        photoAlbumLists.accept(randomPhoto)
    }
//    public func photoCellTapped() {}
    
    public func updatePhotos(index: Int) {
        var randomImageArray: [Int] = self.remainingImageNumberArray.shuffled()
        let newImageNumber = randomImageArray.removeLast()
        let removedImageNumber: Int = self.registeredImageNumberArray[index]

        self.registeredImageNumberArray[index] = newImageNumber
        randomImageArray.append(removedImageNumber)
        self.remainingImageNumberArray = randomImageArray
        let updatedNewArray = convertIntToStringArray(from: self.registeredImageNumberArray)
        
        photoAlbumLists.accept(updatedNewArray)
    }
    
    public func refresh() {
        let newRandomImageArray: [String] = selectRandomImageName(from: imageNumberArray, count: 4, remaining: remainingImageNumberArray, registered: registeredImageNumberArray)
        
        photoAlbumLists.accept(newRandomImageArray)
    }
    
    /// Does it need new Custom Control?? Rx... DoubleTap..?
    public func animateCellButtonDoubleTapped() {}
    
    public func viewDidLoad() {}
    
    public func viewWillAppear(animated: Bool) {}
}

extension PhotoAlbumViewModel {
    private func selectRandomImageName(from array: [Int], count k: Int, remaining remainingArray: [Int], registered registeredArray: [Int]) -> [String] {
        var dictionary: [Int: Int] = [:]
        var resultIntArray: [Int] = []
        var resultArray: [String] = []

        for (index, item) in array.enumerated() {
            dictionary[index] = item
        }

        for _ in 0..<k {
            guard let randomKey = dictionary.keys.randomElement(), let randomValue = dictionary[randomKey] else { return [] }
            let imageName = "IMG_\(randomValue)"
            resultIntArray.append(randomValue)
            resultArray.append(imageName)
            dictionary[randomKey] = nil
        }

        self.registeredImageNumberArray = resultIntArray
        self.remainingImageNumberArray = Array(dictionary.values)
        return resultArray
    }
    
    private func convertIntToStringArray(from intArrray: [Int]) -> [String] {
        var resultStringArray: [String] = []
        intArrray.forEach {
            let imageName = "IMG_\($0)"
            resultStringArray.append(imageName)
        }
        return resultStringArray
    }
}
