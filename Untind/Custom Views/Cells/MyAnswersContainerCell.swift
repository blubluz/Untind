//
//  MyAnswersContainerCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 07/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class MyAnswersContainerCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var answersTableView: UITableView!
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAnswers(withIndexPath: IndexPath) {
        answersTableView.register(UINib(nibName: "MyAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswersTableViewCell")
        answersTableView.delegate = self
        answersTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnswersTableViewCell") as! MyAnswersTableViewCell
        if indexPath.row % 2 == 1 {
            cell.configureDifferently()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
