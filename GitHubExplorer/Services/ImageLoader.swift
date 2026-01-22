//
//  ImageLoader.swift
//  GitHubExplorer
//
//  Created by Guhan on 09/01/26.
//

import UIKit
import SwiftUI

@Observable class ImageLoader {
    
    var image: Image? = nil
    private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            return //Handle error?
        }
        
        if let cacheImage = cache.object(forKey: url as NSURL) {
            self.image =  Image(uiImage: cacheImage)
            print("Image returned from cache")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                self.image = Image(uiImage: image)
                cache.setObject(image, forKey: url as NSURL)
            }
        } catch {
            //Handle error
            print("Image Loader error: \(error.localizedDescription)")
        }
    }
}
