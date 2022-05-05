//
//  SummaryTableCell.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import UIKit

class SummaryTableCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!{
        didSet{
            self.bgView.layer.cornerRadius = 5.0
            self.bgView.clipsToBounds = true
            self.bgView.layer.borderWidth = 1.0
            self.bgView.layer.borderColor = UIColor.green.cgColor
        }
    }
    @IBOutlet weak var fullExchangeNameLbl: UILabel!
    @IBOutlet weak var marketLbl: UILabel!
    @IBOutlet weak var priceHintLbl: UILabel!
    @IBOutlet weak var symbolLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
