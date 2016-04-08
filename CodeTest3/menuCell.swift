//
//  menuCell.swift
//  
//
//  Created by alexfu on 3/25/16.
//
//

import UIKit

class menuCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!

    @IBOutlet weak var caption: UILabel!
    
    func config(item:Item) {
        
        if let text = item.caption
        {
            caption.text = text
        } else
        {
            caption.text = ""
        }
        if (item.original) == nil
        {
            userInteractionEnabled = false
        }
    }
    func setImageForThumb(image: UIImage) {
        self.thumbView.image = image
        
        self.setNeedsLayout()
    }
    
}
