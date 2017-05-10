//
//  PrayersServerConnectionModel.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-10.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import Foundation

let pBaseURL = "https://pray-4-me.herokuapp.com/" //"http://nathans-macbook-pro.local:5000/"
let pPrayerRequests = "prayerRequests/"
let pFiles = "files"

// prayerRequests/global will be all global prayers
// prayerRequests/friendsOnly will be all friends only prayers which will require a query search for friend IDs
// prayerRequests/FBID/pivate will be all private prayers
// prayerRequests/FBID/following will be all following prayers... right now it is prayerRequests/a;sdkjfhlkasdjfh/FBID lol. CATHY IS SHORT
// prayerRequests/prayerID/comments will be for all comments on prayers

class PrayersServerConnectionModel {

	// MARK: Strictly Server requests

	// MARK: Main Prayer Feed

	func importPrayerFeed(_ dataRecivedCallback: (() -> ())? = nil) {
		self.prayers.removeAll()
		let urlForRequestFetching = pBaseURL + pPrayerRequests
		var request = URLRequest(url: URL(string: urlForRequestFetching)!)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		let defaultConfiguation = URLSessionConfiguration.default
		let sessionForImport = URLSession(configuration: defaultConfiguation)

		let receiveTask = sessionForImport.dataTask(with: request) {
			(data, response, error) in
			if error == nil {
			let receivedArrayFromResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
			print(" From heroku we got this back: \(String(describing: receivedArrayFromResponse))")
				if let unwrappedRecievedArray = receivedArrayFromResponse as? [Dictionary<AnyHashable, Any>] {
					self.parseAndAddPrayersToFeed(incomingArray: unwrappedRecievedArray, dataRecivedCallback)
				} else {
					dataRecivedCallback?()
				}
			} else {
				dataRecivedCallback?()
			}

		}

		receiveTask.resume()

	}

	func savePrayerToServer(prayerToBeSent: PrayerRequest, _ dataSavedCallback: (() -> ())? = nil) {

		let prayerRequestsPath = pBaseURL + pPrayerRequests
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
			if error == nil {
			let successfulResponseArray = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
			print("We got this back: \(String(describing: successfulResponseArray))")
			self.parseAndAddPrayersToFeed(incomingArray: [successfulResponseArray as! Dictionary<AnyHashable, Any>], dataSavedCallback)
			} else {
				dataSavedCallback?()
			}
		})

		storeDataTask.resume()

	}

	func deletePrayerFromServer(prayerToBeDeleted: PrayerRequest) {
		let prayerRequestsPath = pBaseURL + pPrayerRequests + prayerToBeDeleted.prayerServerID!
		var requestToDelete = URLRequest(url: URL(string: prayerRequestsPath)!)
		requestToDelete.httpMethod = "DELETE"

		let prayerToBeDeletedAsJson = try? JSONSerialization.data(withJSONObject: prayerToBeDeleted.convertToDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
		requestToDelete.httpBody = prayerToBeDeletedAsJson

		requestToDelete.addValue("application/json", forHTTPHeaderField: "Content-type")

		let defaultSessionConfiguration = URLSessionConfiguration.default
		let sessionToDelete = URLSession(configuration: defaultSessionConfiguration)

		let deleteTask = sessionToDelete.dataTask(with: requestToDelete) { (data, responseFromServer, error) in
			if error == nil {
				let arrayResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
				print("This after we delete: \(String(describing: arrayResponse)) with response \(String(describing: responseFromServer))")
			}
		}

		deleteTask.resume()

	}

	//MARK: Subscriptions Requests

	//TODO: Integrate posting pictures and storing them on "files" path

	func subscribeToPrayer(prayerToSubscribeTo: PrayerRequest, _ dataSavedCallback: (() -> ())? = nil) {
		let subscribeToPath = pBaseURL + pPrayerRequests + FacebookUser.sharedInstanceOfMe.userID! + "/subscribedPrayers"
		print(" path it here \(subscribeToPath)")
		let urlWherePrayersYouSubscribeToAre = URL(string: subscribeToPath)
		var requestToSubscribe = URLRequest(url: urlWherePrayersYouSubscribeToAre!)
		requestToSubscribe.httpMethod = "POST"

		let prayerBodyAsJSON = try? JSONSerialization.data(withJSONObject: prayerToSubscribeTo.convertToDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
		print(" HELLO \(String(describing: prayerBodyAsJSON))")
		requestToSubscribe.httpBody = prayerBodyAsJSON

		requestToSubscribe.addValue("application/json", forHTTPHeaderField: "Content-type")

		let configurationForUploadToSubscribe = URLSessionConfiguration.default
		let sessionToSubscribe = URLSession(configuration: configurationForUploadToSubscribe)

		let subscribeTask = sessionToSubscribe.dataTask(with: requestToSubscribe) { data, responseFromServer, error in
			if error == nil {
				let successfulUploadResponseArray = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
				print("No problem here! :) \(String(describing: successfulUploadResponseArray))")
				self.parseAndAddPrayersToSubscribedFeed(incomingArray: [successfulUploadResponseArray as! Dictionary<AnyHashable,Any>], dataSavedCallback)
			} else {
				dataSavedCallback?()
			}
		}

		subscribeTask.resume()

	}

	func importSubscribedPrayers(_ dataRecivedCallback: (() -> ())? = nil) {
		let stringToGetSubscribedPrayers = pBaseURL + pPrayerRequests + FacebookUser.sharedInstanceOfMe.userID! + "/subscribedPrayers"
		let urlGetSubscribedPrayers = URL(string: stringToGetSubscribedPrayers)
		var requestForSubscribedPrayers = URLRequest(url: urlGetSubscribedPrayers!)
		requestForSubscribedPrayers.httpMethod = "GET"
		requestForSubscribedPrayers.addValue("application/json", forHTTPHeaderField: "Accept")

		let configurationForSession = URLSessionConfiguration.default
		let sessionForSubscriptionImport = URLSession(configuration: configurationForSession)

		let importSubscribedPrayersDataTask = sessionForSubscriptionImport.dataTask(with: requestForSubscribedPrayers) { data, responseArray, error in
			if error == nil {
				let responseArray = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
				print("Subscibed to: \(String(describing: responseArray))")
				if let unwrappedRecievedArray = responseArray as? [Dictionary<AnyHashable, Any>] {
					self.parseAndAddPrayersToSubscribedFeed(incomingArray: unwrappedRecievedArray, dataRecivedCallback)
				} else {
					dataRecivedCallback?()
				}
			} else {
				dataRecivedCallback?()
			}
		}

		importSubscribedPrayersDataTask.resume()
	}

	func unsubscribeFromPrayer(unsubscribeFrom thisPrayer: PrayerRequest, _ dataRecivedCallback: (() -> ())? = nil) {
		let stringWhereSubscribedPrayersAre = pBaseURL + pPrayerRequests + FacebookUser.sharedInstanceOfMe.userID! + "/subscribedPrayers/" + thisPrayer.prayerServerID!
		let urlForDelete = URL(string: stringWhereSubscribedPrayersAre)
		var requestForUnsubscribe = URLRequest(url: urlForDelete!)
		requestForUnsubscribe.httpMethod = "DELETE"

		let prayerToUnsubscribeFromAsJson = try? JSONSerialization.data(withJSONObject: thisPrayer.convertToDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
		requestForUnsubscribe.httpBody = prayerToUnsubscribeFromAsJson

		requestForUnsubscribe.addValue("application/json", forHTTPHeaderField: "Content-type")

		let configurationForSession = URLSessionConfiguration.default
		let sessionForUnsubscribing = URLSession(configuration: configurationForSession)

		let unsubscriptionTask = sessionForUnsubscribing.dataTask(with: requestForUnsubscribe) { data, response, error in
			if error == nil {
				let responseArray = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
				print("Successfully unsubscribed from prayer with ID: \(String(describing: thisPrayer.prayerServerID)) and response \(String(describing: responseArray))")
			}
		}

		unsubscriptionTask.resume()
	}

	// MARK: Handle server response

	var prayers = [PrayerRequest]()

	func parseAndAddPrayersToFeed(incomingArray: [Dictionary<AnyHashable, Any>], _ readyToPopulateCallback: (() -> ())? = nil) {
		self.prayers = []
		for aPrayer in incomingArray {
			let prayerCandidate = PrayerRequest(dictionaryWithInfo: aPrayer)
			self.prayers.append(prayerCandidate)
		}
		readyToPopulateCallback?()
	}

	var subscribedPrayers = [PrayerRequest]()

	func parseAndAddPrayersToSubscribedFeed(incomingArray: [Dictionary<AnyHashable, Any>], _ readyToPopulateCallback: (() -> ())? = nil) {
		self.subscribedPrayers = []
		for aPrayer in incomingArray {
			let prayerCandidate = PrayerRequest(dictionaryWithInfo: aPrayer)
			self.subscribedPrayers.append(prayerCandidate)
		}
		readyToPopulateCallback?()
	}
}
