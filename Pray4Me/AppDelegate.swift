//
//  AppDelegate.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-02-25.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var prayerRequests = [PrayerRequest]()

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		prayerRequests = [PrayerRequest]() /* capacity: 20 */
		var prayer = PrayerRequest()
		prayer.userName = "Bill Evans"
		prayer.requestString = "Tic-Tac-Toe"
		prayer.reputation = 4
		prayer.userAvatar = #imageLiteral(resourceName: "Rayna_Blinding_Teeth")
		prayerRequests.append(prayer)
		prayer = PrayerRequest()
		prayer.userName = "Oscar Peterson"
		prayer.requestString = "Spin the Bottle a;jfha; sldkfja; sldkfjal;sd kjfa;lk sdjf;lask djf;laksdjf ;laksdjf;la ksdjfl;a ksdjf;l kajsd;lf k jasl;d fjkads;fsk l;kkdl;sfjk;ld skfjas;d lkfjadl s;kfjas;ld kfja;lskdfj; laskdjf;laskdj f;laskdjf;laskd jfl;aksd jf;la ksjdfl; kajsd;lkf ja;sldkfj;l asdkfj;lasdkj f;laskdjf;lkasdj f;lkasjd;lkfjadls;k fjl;as dkjfl;askd jf;laksdjf ;lkasdjfl ;kasdjf;lkasjd ;lfkjas; ldkfja;lsk djf;laskdjf ;lkasdjf;l aksdjf;la ksjdfl; kasdj"
		prayer.reputation = 5
		prayer.userAvatar = UIImage(named: "Rayna_Future_Programmer")
		prayerRequests.append(prayer)
		prayer = PrayerRequest()
		prayer.userName = "Dave Brubeck"
		prayer.requestString = "Texas Hold’em Poker"
		prayer.reputation = 2
		prayer.userAvatar = UIImage(named: "Rayna_Smarticle_Particle")
		prayerRequests.append(prayer)
		let tabBarController: UITabBarController? = (self.window?.rootViewController as? UITabBarController)
		let navigationController: UINavigationController? = tabBarController?.viewControllers?[0] as! UINavigationController?
		let prayerFeedTableViewController: PrayerFeedTableViewController? = navigationController?.viewControllers[0] as! PrayerFeedTableViewController?
		prayerFeedTableViewController?.prayerRequests = prayerRequests
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

