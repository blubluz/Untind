//
//  TabBarViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var controllerContainerView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var circleView: TabBarCircleView!
    @IBOutlet var tabBarButtons: [UITabBarButton]!
    
    private var selectedButton: UIButton?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.center = tabBarButtons[0].center
        controllerContainerView.roundCorners(cornerRadius: 35, corners: [.bottomLeft,.bottomRight])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarButtons[0].isSelected = true
        selectedButton = tabBarButtons[0]
        circleView.backgroundColor = UIColor.peachOrange
        circleView.layer.cornerRadius = 22
        circleView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TEST: Add initial controller here for testing purpose
        
        let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.addChild(feedVC)
        feedVC.view.frame = self.controllerContainerView.frame
        self.controllerContainerView.addSubview(feedVC.view)
    }
    
    //MARK: - Button Actions
    @IBAction func feedButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    @IBAction func chatButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    @IBAction func notificationsButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    @IBAction func profileButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    
    
    //MARK: - Helper functions
    func moveCircle(toButton button: UIButton) {
        selectedButton?.isSelected = false
        selectedButton = button
        button.isSelected = true
        circleView.move(toButton: button)
    }
}
