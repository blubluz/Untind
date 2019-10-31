//
//  ReportReasonCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 15/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ReportReasonCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.layer.cornerRadius = circleView.frame.size.height/2
        circleView.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.checkMark.transform = CGAffineTransform.identity
            }) { (completed) in
                
            }
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.checkMark.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (completed) in
                
            }
        }
    }
    
    func configureWith(reason: String) {
        reasonLabel.text = reason
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleView.alpha = 1
        checkMark.transform = CGAffineTransform.identity
        checkMark.alpha = 0
    }
    
}
