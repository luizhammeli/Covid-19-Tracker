//
//  CountryCasesCellPresenter.swift
//  Covid-19 Tracker
//
//  Created by Luiz Diniz Hammerli on 12/09/22.
//  Copyright © 2022 Luiz Hammerli. All rights reserved.
//

import Foundation

protocol ImageView {
    associatedtype Image: Equatable
    func display(image: Image?)
}

final class CountryCasesCellPresenter<View: ImageView, Image> where View.Image == Image {
    let loader: ImageLoader
    let imageView: View
    private let imageTransformer: (Data) -> Image?

    init(loader: ImageLoader, imageView: View, imageTransformer: @escaping (Data) -> Image?) {
        self.loader = loader
        self.imageView = imageView
        self.imageTransformer = imageTransformer
    }
    
    func loadImage(url: String) {
        loader.load(url: url) { [weak self] result in
            if let data = try? result.get(), let image = self?.imageTransformer(data) {
                self?.imageView.display(image: image)
            } else {
                self?.imageView.display(image: nil)
            }
        }
    }
}
