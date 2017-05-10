//
//  BibleCollectionViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-27.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit


class BibleCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Number of Chapter in the Bible
		return 66
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bibleChapterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BibleChapterCategoryCellIdentifier", for: indexPath) as! BibleChapterCollectionViewCell

        return bibleChapterCell
    }
}
