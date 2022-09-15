//
//  GoodOnesApp.swift
//  GoodOnes
//
//  Created by Yuri Chaves on 14/09/22.
//

import SwiftUI

@main
struct GoodOnesApp: App {
    var body: some Scene {
        WindowGroup {
            Composition.makeIntroductionView()
        }
    }
}


final class Composition {
    static func makePhotosView() -> PhotosView {
        let userDefaults = UserDefaultsPersistence(userDefaults: UserDefaults.standard)
        let imagePickerManager = ImagePickerManager()
        let localFetchPhotos = LocalFetchPhotos(userDefaults: userDefaults, pickerManager: imagePickerManager)
        let fetchImageUseCase = PhotosUseCase(localFetchPhoto: localFetchPhotos)
        let updateAssetsUseCase = UpdateAssetsUseCase(localFetchPhoto: localFetchPhotos)

        let viewModel = PhotosViewModel(photosUseCase: fetchImageUseCase, updateAssetUseCase: updateAssetsUseCase)
        return PhotosView(viewModel: viewModel)
    }

    static func makeIntroductionView() -> IntroductionView {
        return IntroductionView()
    }
}
