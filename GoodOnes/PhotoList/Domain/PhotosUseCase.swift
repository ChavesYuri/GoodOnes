
import Foundation
import UIKit
import PhotosUI

protocol LocalFetchImageProtocol {
    typealias Result = Swift.Result<[UIImage], Error>
    func loadImages() -> PHFetchResult<PHAsset>
    func getCachedImages() -> [Date]
    func updateCachedImages(images: [Date])
}

final class PhotosUseCase: PhotosUseCaseProtocol {
    private var photos: [UIImage] = []

    private let localFetchPhoto: LocalFetchImageProtocol

    init(localFetchPhoto: LocalFetchImageProtocol) {
        self.localFetchPhoto = localFetchPhoto
    }

    func execute(completion: (Result<[PHAsset], Error>) -> Void) {
        let processedPhotos = localFetchPhoto.getCachedImages()

        let phAssets = localFetchPhoto.loadImages()
        if phAssets.count > 0 {
            var assets: [PHAsset] = []
            for i in 0..<phAssets.count {
                let asset = phAssets.object(at: i)
                assets.append(asset)
            }

            let modificationDateAssets = assets.compactMap { $0.modificationDate }
            let filteredAsset = modificationDateAssets.filter { !processedPhotos.contains($0) }

            let resultAssets = assets.filter({ filteredAsset.contains($0.modificationDate ?? Date())})

            completion(.success(resultAssets))
        } else {
            completion(.failure(NSError()))
        }
    }
}
