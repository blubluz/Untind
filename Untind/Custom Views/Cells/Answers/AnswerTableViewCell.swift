//
//  AnswerTableViewCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 20/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum Vote {
    case upvote
    case downvote
    case none
}

protocol AnswerCellDelegate: class {
    func didTapProfile(profile: Profile)
    func didVote(value: Vote, answer: Answer)
}

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerAuthorAvatar: UIImageView!
    @IBOutlet weak var answerAuthorLabel: UILabel!
    @IBOutlet weak var answerPostDateLabel: UILabel!
    @IBOutlet weak var answerUpvotesLabel: UILabel!
    weak var delegate : AnswerCellDelegate?
    weak var answer : Answer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor(red: 32, green: 206, blue: 183, alpha: 1).cgColor
        containerView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureWith(answer: Answer) {
        self.answer = answer
        answerLabel.text = answer.answerText
        answerAuthorLabel.text = answer.author.username
        answerPostDateLabel.text = answer.postDate.toFormattedString()
        if answer.upvotes > 0 {
            answerUpvotesLabel.text = "+\(answer.upvotes)"
        } else {
            answerUpvotesLabel.text = "\(answer.upvotes)"
        }
    }
    
    @IBAction func didTapAuthorProfile(_ sender: Any) {
        if let author = answer?.author {
            delegate?.didTapProfile(profile: author)
        }
    }
    
    @IBAction func upvoteTapped(_ sender: Any) {
        if let answer = answer {
            delegate?.didVote(value: .upvote, answer: answer)
        }
    }
    
    @IBAction func downvoteTapped(_ sender: Any) {
        if let answer = answer {
            delegate?.didVote(value: .downvote, answer: answer)
        }
    }
}
