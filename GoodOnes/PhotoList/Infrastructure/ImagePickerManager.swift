import Foundation
import PhotosUI

final class ImagePickerManager: imagePickerManagerProtocol {
    private let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 20

        return options
    }()


    func fetchImages() -> PHFetchResult<PHAsset> {
        PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
}
