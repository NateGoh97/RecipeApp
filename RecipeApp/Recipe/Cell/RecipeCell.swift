//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    static let cellId = "RecipeCell"

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var recipe: Recipe? {
        didSet {
            imgView.image = UIImage(data: recipe!.thumbnail!)
            titleLabel.text = recipe?.title
        }
    }
}
