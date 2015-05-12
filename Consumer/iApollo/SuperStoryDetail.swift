//
//  SuperStoryDetail.swift
//  InfoMaxApollo
//
//  Created by Shreya Garg on 4/21/15.
//  Copyright (c) 2015 akash_kapoor. All rights reserved.
//

import Foundation
import UIKit
import SwiftNDN

class SuperStoryDetail: UIViewController, UITableViewDataSource,UITableViewDelegate, InfoMaxConsumerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfTweets:[Tweet] = [Tweet]()
    var selectedStory = ""
    var selectedStorySuffix = ""
    
    var consumer: InfoMaxConsumer!
    var prefix: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().backgroundColor = UIColor.lightGrayColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        println(selectedStorySuffix)
        
        openInfoMaxConnection()
    }
    
    func openInfoMaxConnection()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.consumer = InfoMaxConsumer(delegate: self, prefix: self.prefix, forwarderIP: "72.36.112.82", forwarderPort: 6363)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpTweets(){
        print("setting up")
        var tweet1 = Tweet(userName: "mekasa ", tweet: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took.", time: " April 21, 2015 - 12:23 pm ", imageName: "q.png", suffix:"")
        var tweet2 = Tweet(userName: "sukasa", tweet: "u r a tweet, we are a tweet", time: "6pm", imageName: "q.png", suffix:"")
        var tweet3 = Tweet(userName: "helloo", tweet: "lets tweet this world", time: "5pm", imageName: "q.png", suffix:"")
        var tweet4 = Tweet(userName: "abcd", tweet: "tweeting all the way", time: "3pm", imageName: "q.png", suffix:"")
        var tweet5 = Tweet(userName: "asdfgh", tweet: "huurayy, yayayayay", time: "5pm", imageName: "q.png", suffix:"")
        var tweet6 = Tweet(userName: "qwerty", tweet: "lets do this !", time: "tg", imageName: "q.png", suffix:"")
        
        arrayOfTweets.append(tweet1)
        arrayOfTweets.append(tweet2)
        arrayOfTweets.append(tweet3)
        arrayOfTweets.append(tweet4)
        arrayOfTweets.append(tweet5)
        arrayOfTweets.append(tweet6)
        print("done setting")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1") as! CustomCell

        let tweet = arrayOfTweets[indexPath.row]
        cell.setCell(tweet.userName, tweet: tweet.tweet, time: tweet.time, imageName: tweet.imageName)
        return cell
    }
    
    func onOpen() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.consumer.getNearestNeighbor(self.selectedStorySuffix)
        }
    }
    func onClose() {
        
    }
    func onData(i: Interest, d: Data) {
        var rawContent = d.getContent()
        var tweetText = NSString(bytes: rawContent, length: rawContent.count, encoding: NSUTF8StringEncoding)
        var tweetStr = String(tweetText!)
        
        var error: NSError? = nil;
        let JSONData = tweetStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        var tweetDict = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: &error) as! NSDictionary
        
        var twe = Tweet(userName: " ", tweet: tweetDict.valueForKey("text") as! String, time: tweetDict.valueForKey("created_at") as! String, imageName: "q.png", suffix:i.name.toUri())
        
        arrayOfTweets.append(twe)
        
        var fb = NSIndexPath(forRow: self.arrayOfTweets.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([fb], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func onError(reason: String) {
        
    }

}
