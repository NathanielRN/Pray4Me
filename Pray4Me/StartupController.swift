//
//  StartupController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-02.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class StartupController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		var prayerRequests = [PrayerRequest]() /* capacity: 20 */
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
		let tabBarController: UITabBarController? = (self as UITabBarController)
		let navigationController: UINavigationController? = tabBarController?.viewControllers?[0] as! UINavigationController?
		let prayerFeedTableViewController: PrayerFeedTableViewController? = navigationController?.viewControllers[0] as! PrayerFeedTableViewController?
		prayerFeedTableViewController?.prayerRequestsSource.prayerRequests = prayerRequests

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
