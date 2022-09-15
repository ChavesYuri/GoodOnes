//
//  IntroductionView.swift
//  GoodOnes
//
//  Created by Yuri Chaves on 15/09/22.
//

import SwiftUI

struct IntroductionView: View {

    private let tips: [String] = ["📷 We need you to permit the access to your photo gallery so that we can show your photos. Don't forget it.", "👆 Swipe right if you liked the photo and left if you don't", "📲 The app show the 20 latest photos from you camera roll."]

    @State var moveToNextScreen = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome to the favorite photos app")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()

                            Text("Those are some tips to get a good experience using the app:")
                                .font(.headline)
                                .fontWeight(.medium)

                        }.padding()

                        ForEach(tips, id: \.self) {
                            Text($0)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                        }.padding()
                    }

                }

                Spacer()

                Button(action: {
                    moveToNextScreen = true
                }) {
                    Text("Start")
                        .font(.system(size: 18))
                        .padding([.leading, .trailing], 60)
                        .padding([.bottom, .top], 20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .background(.green) // If you have this
                .cornerRadius(25)
                .padding(.bottom, 30)

            }
        }
        .navigationTitle("Introduction")
        .navigate(to: Composition.makePhotosView(), when: $moveToNextScreen)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
