//
//  Async.swift
//  DeinDeal
//
//  Created by Honceriu Mihai on 13/10/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
class Async: NSObject {
	
	class var mainQueue: DispatchQueue { return DispatchQueue.main }
	
	enum QueueType {
		case serial, concurrent
	}
	
	/**
	Creates a dispatch_queue_t with a given label and type.
	
	- parameter label: The label of the queue.
	- parameter type:  The type of the queue: `Serial` or `Concurrent`.
	
	- returns: The newly created queue.
	*/
	class func createQueue(label: String, type: QueueType) -> DispatchQueue {
		return DispatchQueue(
			label: label,
			attributes: type == .serial ? DispatchQueue.Attributes() : DispatchQueue.Attributes.concurrent
		)
	}
	
	class func createQueueBlock(_ block: @escaping () -> Void) -> ()->() {
		return block
	}
	
	/**
	Runs a closure on the `global_queue` with a low priority.
	
	- parameter closure: The closure to be run.
	*/
	class func low(_ closure: @escaping () -> ()) {
		
		DispatchQueue.global(qos: .utility).async {
			closure()
		}
	}
	
	/**
	Runs a closure on the `global_queue` with a default priority.
	
	- parameter closure: The closure to be run.
	*/
	class func normal(_ closure: @escaping () -> ()) {
		
		DispatchQueue.global(qos: .default).async {
			closure()
		}
	}
	
	/**
	Runs a closure on the `global_queue` with a high priority.
	
	- parameter closure: The closure to be run.
	*/
	class func high(_ closure: @escaping () -> ()) {
		
		DispatchQueue.global(qos: .userInteractive).async {
			closure()
		}
	}
	
	/**
	Runs a closure on the `global_queue` with a background priority.
	
	- parameter closure: The closure to be run.
	*/
	class func background(_ closure: @escaping () -> ()) {
		
		DispatchQueue.global(qos: .background).async {
			closure()
		}
	}
	
	/**
	Runs a closure on the `main_queue`.
	
	- parameter closure: The closure to be run.
	*/
	class func main(_ closure: @escaping () -> ()) {
		DispatchQueue.main.async {
			closure()
		}
	}
	
	class func queue(_ queue: DispatchQueue, onMain: Bool = false, closure: @escaping () -> Void) {
		if onMain {
			queue.async {
				main { closure() }
			}
		}
		else {
			queue.async(execute: closure)
		}
	}
	
	/**
	Runs a closure on the `main_queue` after the given delay, if no queue is passed in to be used.
	
	- parameter delay:   The time to wait until the closure is run, in seconds.
	- parameter closure: The closure to be run.
	*/
	class func delay(_ delay: Double, onQueue queue: DispatchQueue = Async.mainQueue, closure: @escaping () -> ()) {
		
		queue.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
			execute: closure
		)
	}
}
