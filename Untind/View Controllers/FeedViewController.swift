//
//  FeedViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var swipeableCardViewContainer: SwipeableCardViewContainer!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeableCardViewContainer.dataSource = self
    }
}


//MARK: - SwipeableCardViewDataSource
extension FeedViewController: SwipeableCardViewDataSource {
    func numberOfCards() -> Int {
        return 10
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let cardView = SwipeableCardViewCard()
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
}
