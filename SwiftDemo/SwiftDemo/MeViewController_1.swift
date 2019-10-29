//
//  MeViewController_1.swift
//  SwiftDemo
//
//  Created by ndl on 2019/10/10.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

class MeViewController_1: UIViewController {
    var person1: Person1!
    var animal: Animal!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

        person1.name = "MeViewController_1"
        animal.name = "MeViewController_1"
        print("MeViewController_1: person1 = \(person1!) animal = \(animal!)")
    }
}
