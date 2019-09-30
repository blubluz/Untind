//
//  MyAnswersContainerCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 07/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

protocol AnswersDelegate: class {
    func didTap(answer: Answer)
}
class MyAnswersContainerCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    @IBOutlet weak var answersTableView: UITableView!
    private var indexPath: IndexPath?
    weak var draggingDelegate : DraggingDelegate?
    weak var answerDelegate: AnswersDelegate?
    private var shouldClose = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var answers : [Answer]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func set(answers: [Answer]?) {
        self.answers = answers
        
        if answers != nil {
            answersTableView.isHidden = false
            activityIndicator.stopAnimating()
        }
        
        answersTableView.register(UINib(nibName: "MyAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswersTableViewCell")
        answersTableView.delegate = self
        answersTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnswersTableViewCell") as! MyAnswersTableViewCell
        cell.configureWith(answer: answers![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
        self.answerDelegate?.didTap(answer: answers![indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            shouldClose = true
        }
        
        if shouldClose == true && scrollView.contentOffset.y <= 0{
            if scrollView.contentOffset.y < -100 {
                draggingDelegate?.didCloseByDragging()
            }
        } else {
            shouldClose = false
        }
    }
}
