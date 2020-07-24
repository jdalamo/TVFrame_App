//
//  PhotosTableViewCell.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosTableViewCell: UITableViewCell {
    
    static let identifier = "PhotosTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    let placeholderImage = UIImage(named: "placeholder")
    
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    public func configure(with photoName: String, imageUrl: URL) {
        photoNameLabel.text = photoName
        photoImageView.sd_setImage(with: imageUrl,
                                   placeholderImage: placeholderImage,
                                   options: [SDWebImageOptions.highPriority, .refreshCached],
                                   context: nil,
                                   progress: nil,
                                   completed: { downloadedImage, downloadException, cacheType, downloadURL in
                                    if let downloadException = downloadException {
                                        print("Error downloading the image: \(downloadException.localizedDescription)")
                                    } else {
                                        print("Successfully downloaded image: \(downloadURL?.absoluteString ?? "default value")")
                                    }
                                    
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
