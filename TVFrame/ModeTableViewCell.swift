//
//  ModeTableViewCell.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/18/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class ModeTableViewCell: UITableViewCell {
    
    static let identifier = "ModeTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public func configure(with modeName: String, imageName: String) {
        modeNameLabel.text = modeName
        modeRadioImage.image = UIImage(systemName: imageName)
    }
    
    @IBOutlet weak var modeNameLabel: UILabel!
    @IBOutlet weak var modeRadioImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modeRadioImage.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
