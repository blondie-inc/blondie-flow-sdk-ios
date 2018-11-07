//
//  ViewController.swift
//  Blondie Example Swift
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var triggerEventButton: UIButton!
	
	private var eventCounter = 0

	@IBAction func triggerEventAction(_ sender: UIButton) {
		Blondie.triggerEvent(withName: String("Event\(eventCounter)"), metaData: ["param1": "value1",
																				  "param2": "value2"])
		eventCounter+=1
	}

}
