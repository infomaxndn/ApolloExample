//
//  StoryDetailViewController.swift
//  InfoMaxApollo
//
//  Copyright (c) 2015 akash_kapoor. All rights reserved.
//

import UIKit
import SwiftNDN

class StoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InfoMaxConsumerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var arrayOfTweets:[Tweet] = [Tweet]()
    var selectedStory = ""
    var storyInterest = ""
    
    var consumer: InfoMaxConsumer!
    var prefix: String!
    
    var getCount = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nextBut = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.Plain, target: self, action: "buttonAction:" )
        self.navigationItem.setRightBarButtonItem(nextBut, animated: true)
        
        // Do any additional setup after loading the view.
        UINavigationBar.appearance().backgroundColor = UIColor.lightGrayColor()
        self.automaticallyAdjustsScrollViewInsets = false

        openInfoMaxConnection()
        
    }

    func openInfoMaxConnection()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        self.prefix = self.storyInterest
        self.consumer = InfoMaxConsumer(delegate: self, prefix: self.prefix, forwarderIP: "72.36.112.82", forwarderPort: 6363)
        }
    }
    
    func buttonAction(sender:UIButton!)
    {
        getNextTweetSet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: InfoMaxDelegate
    
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
    
    func getNextTweetSet() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.consumer.get(self.getCount)
            self.getCount = self.getCount + 1
        }
    }
    
    func onOpen() {
        getNextTweetSet()
    }
    
    func onError(reason: String) {
    }
    
    func onClose() {
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfTweets.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? CustomCell

        let tweet = arrayOfTweets[indexPath.row]
        cell!.setCell(tweet.userName, tweet: tweet.tweet, time: tweet.time, imageName: tweet.imageName)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let indexPath = self.tableView.indexPathForSelectedRow()?.row
        //var selectedTweet = self.arrayOfTweets[indexPath!]
        //self.consumer.getNearestNeighbor(selectedTweet.suffix)
        //self.performSegueWithIdentifier("SuperStoryDetailSegue", sender: tableView)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "SuperStoryDetailSegue" {
            if let destinationVC = segue.destinationViewController as? SuperStoryDetail{
                let indexPath = self.tableView.indexPathForSelectedRow()?.row
                var selectedTweet = self.arrayOfTweets[indexPath!]
                print(selectedTweet.tweet)
                destinationVC.title = selectedTweet.tweet
                destinationVC.prefix = self.prefix
                destinationVC.selectedStorySuffix = selectedTweet.suffix
            }
            
        }
    }}
