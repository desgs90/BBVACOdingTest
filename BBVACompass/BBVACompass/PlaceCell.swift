//
//  PlaceCell.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    //MARK:- IBOUtlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var detail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        name.text = ""
        detail.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
