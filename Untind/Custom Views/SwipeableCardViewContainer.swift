//
//  SwipeableStackView.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

class SwipeableCardViewContainer: UIView, SwipeableViewDelegate {
   
    

    static let horizontalInset: CGFloat = 12.0

    static let verticalInset: CGFloat = 12.0

    var dataSource: SwipeableCardViewDataSource? {
        didSet {
            reloadData()
        }
    }

    var delegate: SwipeableCardViewDelegate?

    private var cardViews: [SwipeableCardViewCard] = []

    private var visibleCardViews: [SwipeableCardViewCard] {
        return subviews as? [SwipeableCardViewCard] ?? []
    }

    fileprivate var remainingCards: Int = 0

    static let numberOfVisibleCards: Int = 2

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else {
            return
        }

        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards

        for index in 0..<min(numberOfCards, SwipeableCardViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }

        if let emptyView = dataSource.viewForEmptyCards() {
            addEdgeConstrainedSubView(view: emptyView)
        }

        setNeedsLayout()
    }

    private func addCardView(cardView: SwipeableCardViewCard, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        if index == 0 {
            cardView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveLinear, animations: {
                cardView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        remainingCards -= 1
    }

    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: SwipeableCardViewCard, atIndex index: Int) {
            let cardViewFrame = bounds
            cardView.frame = cardViewFrame
        if index > 0 {
            cardView.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
            cardView.alpha = 0.35
        }
    }

}

// MARK: - SwipeableViewDelegate

extension SwipeableCardViewContainer {

    
    func didSwipe(onView view: SwipeableView, percent: CGFloat) {
      
    }
    
    
    func didTap(view: SwipeableView) {
        if let cardView = view as? SwipeableCardViewCard,
            let index = cardViews.firstIndex(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }

    func didBeginSwipe(onView view: SwipeableView) {
        // React to Swipe Began?
    }

    func didEndSwipe(onView view: SwipeableView) {
        guard let dataSource = dataSource else {
            return
        }
        
        
        
        var newVisibleCardViews = visibleCardViews
        newVisibleCardViews.removeLast()
        
        // Bring new card on top
        for (cardIndex, cardView) in newVisibleCardViews.reversed().enumerated() {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveLinear, animations: {
                
                cardView.center = self.center
                cardView.transform = CGAffineTransform.identity
                cardView.alpha = 1
                self.setFrame(forCardView: cardView, atIndex: cardIndex)
                
                self.layoutIfNeeded()
            }) { (success : Bool) in
                // Remove swiped card
                view.removeFromSuperview()
            }
        }
        
        
        // Only add a new card if there are cards remaining
        if remainingCards > 0 {
            
            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards
            
            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 1)
        }
    }

}
