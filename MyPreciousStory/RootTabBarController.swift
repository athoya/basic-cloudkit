//
//  RootTabBarController.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 22/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.items?[0].image = #imageLiteral(resourceName: "applemapIcon_25px")
        self.tabBar.items?[0].title = "My Stories"
        self.tabBar.items?[1].image = #imageLiteral(resourceName: "addIcon_25px")
        self.tabBar.items?[1].title = "Save Story"
        
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
