//
//  BusinessTableViewCell.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/31/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit

// MARK: - BusinessTableViewCell

class BusinessTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
