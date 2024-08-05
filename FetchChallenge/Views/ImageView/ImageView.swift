//
//  ImageView.swift
//  FetchChallenge
//
//  Created by Shane Wolf on 8/1/24.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject private var imageViewLoader = ImageViewLoader()
    
    let urlString: String
    
    var body: some View {
        HelperImageView(image: imageViewLoader.imageView)
            .task {
                await imageViewLoader.loadImage(urlString: urlString)
            }
    }
}

private struct HelperImageView: View {
    
    var image: Image?
    
    var body: some View {
        image?
            .resizable()
            .aspectRatio(contentMode: .fill) ??
        Image(systemName: "takeoutbag.and.cup.and.straw")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

@MainActor final class ImageViewLoader: ObservableObject {
    
    @Published var imageView: Image?
    
    func loadImage(urlString: String) async {
        do {
            let uiImage = try await NetworkManager.shared.downloadImage(urlString: urlString)
            
            self.imageView = Image(uiImage: uiImage)
        } catch {
            self.imageView = Image(systemName: "exclamationmark.circle")
        }
    }
}

#Preview {
    ImageView(urlString: MockData.sampleMeal.strMealThumb)
}
