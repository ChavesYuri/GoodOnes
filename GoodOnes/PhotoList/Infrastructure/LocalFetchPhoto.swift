import Foundation
import UIKit
import Photos

protocol imagePickerManagerProtocol {
    func fetchImages() -> PHFetchResult<PHAsset>
}

final class LocalFetchPhotos: LocalFetchImageProtocol {

    let userDefaults: UserDefaultsPersistenceProtocol

    let pickerManager: imagePickerManagerProtocol

    init(
        userDefaults: UserDefaultsPersistenceProtocol,
        pickerManager: imagePickerManagerProtocol
    ) {
        self.userDefaults = userDefaults
        self.pickerManager = pickerManager
    }

    func loadImages() -> PHFetchResult<PHAsset> {
        pickerManager.fetchImages()
    }

    func getCachedImages() -> [Date] {
        userDefaults.getObject(key: UserDefaultsKey.processedImages.rawValue) ?? []
    }

    func updateCachedImages(images: [Date]) {
        userDefaults.setObject(key: UserDefaultsKey.processedImages.rawValue, object: images)
    }
}
