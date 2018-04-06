//
//  MainTableViewCell.swift
//  3DayFlurry
//
//  Created by Alex de France on 4/5/18.
//  Copyright © 2018 Def Labs. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.layer.cornerRadius = 5.0
    }

}
