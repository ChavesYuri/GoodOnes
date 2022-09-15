import Foundation
import PhotosUI

enum UserDefaultsKey: String {
    case processedImages
}

enum ViewState {
    case loaded
    case empty
    case done
    case initial
    case accessDenied
    case error
}

protocol PhotosUseCaseProtocol {
    typealias Result = Swift.Result<[PHAsset], Error>
    func execute(completion: (Result) -> Void)
}

protocol UpdateAssetsUseCaseProtocol {
    func execute(asset: PHAsset)
}

final class PhotosViewModel: ObservableObject {

    @Published var assets: [PHAsset] = []
    @Published var errorString : String = ""
    @Published var isFinished: Bool = false
    @Published var count = 0
    @Published var viewState: ViewState = .initial

    private let photosUseCase: PhotosUseCaseProtocol
    private let updateAssetUseCase: UpdateAssetsUseCaseProtocol

    init(
        photosUseCase: PhotosUseCaseProtocol,
        updateAssetUseCase: UpdateAssetsUseCaseProtocol
    ) {
        self.photosUseCase = photosUseCase
        self.updateAssetUseCase = updateAssetUseCase

        requestLibraryAuth()
    }

    func requestLibraryAuth() {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            guard let self = self else { return }
            switch status {
            case .authorized:
                self.getPhotos()
                self.showErrorMessage("")
            case .denied, .restricted:
                self.showErrorMessage("Photo access permission denied")
                self.viewState = .accessDenied
            case .notDetermined:
                self.showErrorMessage("Photo access permission denied")
                self.viewState = .accessDenied
            default:
                fatalError()
            }
        }
    }

    private func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorString = message
        }
    }

    private func getPhotos() {
        photosUseCase.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let assets):
                DispatchQueue.main.async {
                    self.assets = assets
                    if assets.isEmpty {
                        self.viewState = .empty
                    } else {
                        self.viewState = .loaded
                    }
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.viewState = .error
                    self.errorString =  failure.localizedDescription
                }
            }
        }
    }

    func processedAsset(_ asset: PHAsset, index: Int) {
        assets.remove(at: index)
        updateAssetUseCase.execute(asset: asset)

        if assets.isEmpty {
            count += 1
            viewState = .done
        }
    }
}
