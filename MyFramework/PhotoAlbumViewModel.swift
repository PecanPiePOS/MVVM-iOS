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
    
    /// Call when the indivisual cell is tapped.
    /// Turns out it is unneccessary for the example codes.
//    func photoCellTapped()

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

    var photoAlbumLists: BehaviorSubject<[String]> { get }
    
}

public protocol PhotoAlbumViewModelType {
    var inputs: PhotoAlbumViewModelInputs { get }
    var outputs: PhotoAlbumViewModelOutputs { get }
}

public final class PhotoAlbumViewModel: PhotoAlbumViewModelType, PhotoAlbumViewModelInputs, PhotoAlbumViewModelOutputs {
    
    private let imageNumberArray: [Int] = [2567, 3975, 4004, 4199, 4335, 5275, 5400, 5731, 5774, 5905, 6035, 6041]
    private var registeredImageNumberArray: [Int] = []
    private var remainingImageNumberArray: [Int] = []
    
    public var photoAlbumLists: BehaviorSubject<[String]> {
        let randomPhoto = selectRandomImageName(from: imageNumberArray,
                                                count: 4,
                                                remaining: &remainingImageNumberArray,
                                                registered: &registeredImageNumberArray)
        let subject: BehaviorSubject<[String]> = BehaviorSubject(value: randomPhoto)
        return subject
    }
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    public var inputs: PhotoAlbumViewModelInputs { return self }
    public var outputs: PhotoAlbumViewModelOutputs { return self }
    
//    public func photoCellTapped() {}
    
    public func updatePhotos(index: Int) {
//        var randomImageArray: [Int] = self.remainingImageNumberArray.shuffled()
//        let newImageNumber = randomImageArray.removeLast()
//        let removedImageNumber: Int = registeredImageNumberArray[index]
//
//        registeredImageNumberArray[index] = newImageNumber
//        randomImageArray.append(removedImageNumber)
//        self.remainingImageNumberArray = randomImageArray
//        let updatedNewArray = convertIntToStringArray(from: self.remainingImageNumberArray)
//
//        photoAlbumLists.onNext(updatedNewArray)
    }
    
    public func refresh() {
//        let newRandomImageArray: [String] = selectRandomImageName(from: imageNumberArray, count: 4, remaining: &remainingImageNumberArray, registered: &registeredImageNumberArray)
//        photoAlbumLists.onNext(newRandomImageArray)
    }
    
    /// Does it need new Custom Control?? Rx...
    public func animateCellButtonDoubleTapped() {}
    
    public func viewDidLoad() {}
    
    public func viewWillAppear(animated: Bool) {}
}

extension PhotoAlbumViewModel {
    private func selectRandomImageName<T: Hashable>(from array: [T], count k: Int, remaining remainingArray: inout [T], registered registeredArray: inout [T]) -> [String] {
        var dictionary: [Int: T] = [:]
        var resultIntArray: [T] = []
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

        registeredArray = resultIntArray
        remainingArray = Array(dictionary.values)
        return resultArray
    }
}

//fileprivate func getRandomImageData() -> [PhotoModel] {
//    var exifData: CFDictionary? = nil
//
//}

fileprivate func convertIntToStringArray(from intArrray: [Int]) -> [String] {
    var resultStringArray: [String] = []
    intArrray.forEach {
        let imageName = "IMG_\($0)"
        resultStringArray.append(imageName)
    }
    return resultStringArray
}
