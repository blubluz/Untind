//
//  AnswerTableViewCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 20/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum Vote: Int {
    case upvote = 1
    case downvote = -1
    case novote = 0
    
    static func from(json: [String:Any]?) -> Vote {
        if let json = json, let voteValue = json["value"] as? Int{
            switch voteValue {
            case -1:
                return .downvote
            case 0:
                return .novote
            case 1:
                return .upvote
            default:
                return .novote
            }
        } else {
            return .novote
        }
    }
    
    var opposite : Vote {
        switch self {
        case .upvote:
            return .downvote
        case .downvote:
            return .upvote
        case .novote:
            return .novote
        }
    }
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
    @IBOutlet weak var upvoteButton: VoteButton!
    @IBOutlet weak var downvoteButton: VoteButton!
    weak var delegate : AnswerCellDelegate?
    weak var answer : Answer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor(red: 32, green: 206, blue: 183, alpha: 1).cgColor
        containerView.layer.borderWidth = 1
        upvoteButton.voteType = .upvote
        downvoteButton.voteType = .downvote
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
        switch answer.myVote {
        case .downvote:
            downvoteButton.isSelected = true
        case .upvote:
            upvoteButton.isSelected = true
        case .novote:
            break;
        }
    }
    
    @IBAction func didTapAuthorProfile(_ sender: Any) {
        if let author = answer?.author {
            delegate?.didTapProfile(profile: author)
        }
    }
    
    @IBAction func upvoteTapped(_ sender: Any) {
        //Animate
        upvoteButton.isSelected = !upvoteButton.isSelected
    
        if downvoteButton.isSelected == true {
            downvoteButton.isSelected = false
        }
        
        if let answer = answer {
            var localUpvotes = answer.upvotes
            switch answer.myVote {
            case .upvote:
                localUpvotes -= 1
            case .downvote:
                localUpvotes += 2
            case .novote:
                localUpvotes += 1
            }
               if localUpvotes > 0 {
                     answerUpvotesLabel.text = "+\(localUpvotes)"
                 } else {
                     answerUpvotesLabel.text = "\(localUpvotes)"
                 }
            delegate?.didVote(value: .upvote, answer: answer)
        }
        
    }
    
    @IBAction func downvoteTapped(_ sender: Any) {
        //Animate
        downvoteButton.isSelected = !downvoteButton.isSelected
        if upvoteButton.isSelected {
            upvoteButton.isSelected = false
        }
        
        if let answer = answer {
            var localUpvotes = answer.upvotes
            switch answer.myVote {
            case .upvote:
                localUpvotes -= 2
            case .downvote:
                localUpvotes += 1
            case .novote:
                localUpvotes -= 1
            }
            
             if localUpvotes > 0 {
                                answerUpvotesLabel.text = "+\(localUpvotes)"
                            } else {
                                answerUpvotesLabel.text = "\(localUpvotes)"
                            }
            delegate?.didVote(value: .downvote, answer: answer)
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            downvoteButton.isSelected = false
            upvoteButton.isSelected = false
    }
}
