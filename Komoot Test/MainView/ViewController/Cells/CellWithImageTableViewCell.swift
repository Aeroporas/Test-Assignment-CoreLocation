//
//  CellWithImageTableViewCell.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import UIKit

class CellWithImageTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel! // Used for debug purposes, hidden
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(with model: CellWithImageViewModel) {
        if model.image != nil || model.error != nil {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        locationImageView.image = model.image
        if let error = model.error {
            errorLabel.isHidden = false
            errorLabel.text = error.localizedDescription
        }
        
        dateLabel.text = model.dateString
    }
}
