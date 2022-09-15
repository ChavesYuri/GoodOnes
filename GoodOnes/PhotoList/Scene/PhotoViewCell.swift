
import SwiftUI
import PhotosUI

struct PhotoViewCell: View {
    var onFinish: ((PHAsset) -> Void)?

    @State private var offset = CGSize.zero
    @State private var borderColor = Color.white
    @State private var image: Image?

    let phAsset: PHAsset

    var body: some View {
        let width = UIScreen.main.bounds.width * 0.8
        let height = UIScreen.main.bounds.height * 0.5

        ZStack {

            Rectangle()
                .frame(width: width, height: height)
                .border(borderColor, width: 6.0)
                .cornerRadius(4)

            image?
                .resizable()
                .frame(width: width * 0.97, height: height * 0.97, alignment: .center)
                .aspectRatio(1, contentMode: .fill)
                .cornerRadius(4)

        }
        .onAppear(perform: load)
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                } .onEnded { _ in
                    withAnimation {
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                    
                }
        )
    }

    private func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = .init(width: -500, height: 0)
            onFinish?(phAsset)
        case 150...(500):
            offset = .init(width: 500, height: 0)
            onFinish?(phAsset)
        default:
            offset = .zero
        }
    }

    private func changeColor(width: CGFloat) {
        switch width {
        case -500...(-80):
            borderColor = .red
        case 80...(500):
            borderColor = .green
        default:
            borderColor = .white
        }
    }

    private func load() {
        let request = PHImageRequestOptions()
        request.isSynchronous = false
        request.deliveryMode = .highQualityFormat

        PHImageManager.default().requestImage(for: phAsset, targetSize: .init(), contentMode: .aspectFill, options: request) { image, _ in
            guard let uiImage = image else { return }
            self.image = Image(uiImage: uiImage)
        }
    }

}

struct PhotoViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PhotoViewCell(phAsset: .init())
    }
}
