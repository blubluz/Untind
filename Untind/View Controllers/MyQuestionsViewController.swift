//
//  MyQuestionsViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class MyQuestionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var selectorPointerView: UIView!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var myQuestionsButton: UIButton!
    @IBOutlet weak var myAnswersButton: UIButton!
    @IBOutlet weak var selectorPointerLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: "MyQuestionsContainerCell", bundle: nil), forCellWithReuseIdentifier: "MyQuestionsContainerCell")
        collectionView.register(UINib(nibName: "MyAnswersContainerCell", bundle: nil), forCellWithReuseIdentifier: "MyAnswersContainerCell")

        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(cornerRadius: 30, corners: [.topLeft,.topRight])
        selectorView.layer.cornerRadius = 24
        selectorPointerView.layer.cornerRadius = 22
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyQuestionsContainerCell", for: indexPath) as! MyQuestionsContainerCell
            cell.setQuestions()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAnswersContainerCell", for: indexPath) as! MyAnswersContainerCell
            cell.setAnswers(withIndexPath: indexPath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let completionPercentage = min((scrollView.contentOffset.x * 100) / scrollView.frame.size.width, 100)
        selectorPointerLeadingConstraint.constant = max((selectorView.frame.size.width/2 - 2) * completionPercentage/100,2)
        selectorView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.answerTeal, withPercentage: completionPercentage/100)
        backgroundView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor(red: 249, green: 219, blue: 202, alpha: 1), toColor: UIColor.white, withPercentage: completionPercentage/100)
        
        let questionsButtonColor = UIColor.fadeFromColor(fromColor: UIColor.gray81, toColor: UIColor.white, withPercentage: completionPercentage/100)
        myQuestionsButton.setTitleColor(questionsButtonColor, for: .normal)
        
        let answersButtonColor = UIColor.fadeFromColor(fromColor: UIColor.white, toColor: UIColor.gray81, withPercentage: completionPercentage/100)
        myAnswersButton.setTitleColor(answersButtonColor, for: .normal)
        
        
        print("Completion: \(completionPercentage)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .didSwitchTheme, object: nil, userInfo: ["theme" : indexPath.row == 0 ? ThemeMode.answer : ThemeMode.question])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
