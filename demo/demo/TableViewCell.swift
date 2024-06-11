//
//  TableViewCell.swift
//  demo
//
//  Created by MAC on 07/06/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var subtileLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.outerView.layer.cornerRadius = 10
        self.outerView.layer.borderColor = UIColor.black.cgColor
        self.outerView.layer.borderWidth = 1.0
        // Configure the view for the selected state
    }
    
}
