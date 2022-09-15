import Foundation
import PhotosUI

final class UpdateAssetsUseCase: UpdateAssetsUseCaseProtocol {
    private let localFetchPhoto: LocalFetchImageProtocol

    init(localFetchPhoto: LocalFetchImageProtocol) {
        self.localFetchPhoto = localFetchPhoto
    }

    func execute(asset: PHAsset) {
        guard let assetDate = asset.modificationDate else { return }

        var currentProcessedAssets = localFetchPhoto.getCachedImages()
        currentProcessedAssets.append(assetDate)

        localFetchPhoto.updateCachedImages(images: currentProcessedAssets)
    }
}
