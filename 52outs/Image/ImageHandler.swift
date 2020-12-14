//
//  ImageHandler.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-21.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

class imageHandler {
    func storeImage (_ image: UIImage) {
        Settings().statusChange()
        // Convert to Data
        let fileManager = FileManager.default
        let imageURL  = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePATH = imageURL.path
        let filePATH = imageURL.appendingPathComponent("/Background.png")

        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(imagePATH)")
            for file in files {
                if "\(imagePATH)/\(file)" == filePATH.path{
                    try fileManager.removeItem(atPath: filePATH.path)
                }
            }
        } catch {
                print("could not add image to path:\(error)")
        }
        
        do {
            if let imageData = image.pngData(){
                try imageData.write(to: filePATH, options: .atomic)
            }
        } catch {
            print("couldn't write image")
        }
        Settings.defaults.set(filePATH, forKey: "backgroundImagePath")
    }
    func fetchImage (url: URL) -> UIImage{
        var imageContent: UIImage = UIImage()
        let path = url.path
        if FileManager.default.fileExists(atPath: path){
            if let content = UIImage(contentsOfFile: path){
                imageContent = content
            } else {
                print ("couldn't find image at path")
            }
        } else {
            print ("file don't exist")
        }
        return imageContent
    }
}
