//
//  ContentView.swift
//  GoodOnes
//
//  Created by Yuri Chaves on 14/09/22.
//

import SwiftUI
import PhotosUI
import ConfettiSwiftUI

struct PhotosView: View {

    @ObservedObject var viewModel: PhotosViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .tint(.red)
            case .accessDenied:
                Text("Access Denied! \n You need to allow to use the library on Setting to have a good experience in the app")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

            case .loaded:
                ZStack {
                    ForEach(0..<viewModel.assets.count , id: \.self) { index in
                        PhotoViewCell(onFinish: { asset in
                            viewModel.processedAsset(asset, index: index)
                        }, phAsset: viewModel.assets[index])
                    }
                }

            case .error:
                Text("Sorry! \n We had a problem fetching your images")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

            case .done:
                Text("Congratulations!!!! \n You just used the best way to select your favorite photos")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            case .empty:
                Text("Sorry!!!! \n You don't have photos to show")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }


        }
        .confettiCannon(counter: $viewModel.count)
        .alert(isPresented: .constant(!viewModel.errorString.isEmpty) ) {
            Alert(title: Text("Error"), message: Text(viewModel.errorString), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Composition.makePhotosView()
    }
}
