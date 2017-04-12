//
//  PrayersServerConnectionModel.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-10.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import Foundation

let kBaseURL = "http://ingrids-macbook-pro.local:3000/"
let kPrayerRequests = "prayerRequests/"
let kFiles = "files"

class PrayersServerConnectionModel {

	var prayers = [PrayerRequest]()

	func importPrayerFeed() {
		let urlForRequestFetching = kBaseURL + kPrayerRequests
		var request = URLRequest(url: URL(string: urlForRequestFetching)!)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		let defaultConfiguation = URLSessionConfiguration.default
		let sessionForImport = URLSession(configuration: defaultConfiguation)

		let receiveTask = sessionForImport.dataTask(with: request) {
			(data, response, error) in
			let receivedArrayFromResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
			self.parseAndAddPrayersToFeed(incomingArray: receivedArrayFromResponse as! [Dictionary<AnyHashable, Any>])

		}

		receiveTask.resume()

	}

	func parseAndAddPrayersToFeed(incomingArray: [Dictionary<AnyHashable, Any>]) {
		for aPrayer in incomingArray {
			let prayerCandidate = PrayerRequest(dictionaryWithInfo: aPrayer)
			self.prayers.append(prayerCandidate)
		}
	}

	func savePrayerToServer(prayerToBeSent: PrayerRequest) {

		let prayerRequestsPath = kBaseURL + kPrayerRequests
		let urlWherePrayerWillBeSaved = URL(string: prayerRequestsPath)
		var request = URLRequest(url: urlWherePrayerWillBeSaved!)
		request.httpMethod = "POST"

		let prayerData = try? JSONSerialization.data(withJSONObject: prayerToBeSent.convertToDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
		request.httpBody = prayerData

		request.addValue("application/json", forHTTPHeaderField: "Content-type")

		let configurationForUpload = URLSessionConfiguration.default
		let uploadSession = URLSession(configuration: configurationForUpload)

		let storeDataTask = uploadSession.dataTask(with: request, completionHandler: {
			(data, uploadResponse, error) in
			let successfulResponseArray = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
			print("We got this back: \(String(describing: successfulResponseArray))")
			self.parseAndAddPrayersToFeed(incomingArray: [successfulResponseArray as! Dictionary<AnyHashable, Any>])
		})

		storeDataTask.resume()

	}

	func deletePrayerFromServer(prayerToBeDeleted: PrayerRequest) {
		let prayerRequestsPath = kBaseURL + kPrayerRequests + prayerToBeDeleted.prayerServerID!
		var requestToDelete = URLRequest(url: URL(string: prayerRequestsPath)!)
		requestToDelete.httpMethod = "DELETE"

		let prayerToBeDeletedAsJson = try? JSONSerialization.data(withJSONObject: prayerToBeDeleted.convertToDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
		requestToDelete.httpBody = prayerToBeDeletedAsJson

		requestToDelete.addValue("application/json", forHTTPHeaderField: "Content-type")

		let defaultSessionConfiguration = URLSessionConfiguration.default
		let sessionToDelete = URLSession(configuration: defaultSessionConfiguration)

		let deleteTask = sessionToDelete.dataTask(with: requestToDelete) { (data, responseFromServer, error) in

			let arrayResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
			print("This after we delete: \(String(describing: arrayResponse)) with response \(String(describing: responseFromServer))")
		}

		deleteTask.resume()

	}

	func saveNewImageFirst() {

	}

	func addPrayer() {

	}
}
