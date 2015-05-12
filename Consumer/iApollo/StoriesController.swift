//
//  ViewController.swift
//  InfoMaxApollo
//
//  Copyright (c) 2015 akash_kapoor. All rights reserved.
//

import UIKit
import SwiftNDN

class StoriesController: UIViewController, FaceDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    private var face: Face!
    
    var forwarderIP = "72.36.112.82"
    var forwarderPort:UInt16 = 6363
    var createStoryPrefix = "/Apollo/newStory/"
    var createStorySeperator = "&"
    var storiesInterest = "/Apollo/story"
    
    let storyFeild = UITextField(frame: CGRectMake(10,0,252,25))
    let key1Feild = UITextField(frame: CGRectMake(10,30,252,25))
    let key2Feild = UITextField(frame: CGRectMake(10,60,252,25))
    let key3Feild = UITextField(frame: CGRectMake(10,90,252,25))
    
    @IBAction func addButton(sender: UIBarButtonItem) {
        println("Add Button.")
        
        var alertView = UIView(frame: CGRectMake(0, 0, 255, 200))
        
        storyFeild.placeholder = "Task Name";
        storyFeild.borderStyle = UITextBorderStyle.RoundedRect
        alertView.addSubview(storyFeild)
        
        key1Feild.placeholder = "Keyword 1";
        key1Feild.borderStyle = UITextBorderStyle.RoundedRect
        alertView.addSubview(key1Feild)
        
        key2Feild.placeholder = "Keyword 2";
        key2Feild.borderStyle = UITextBorderStyle.RoundedRect
        alertView.addSubview(key2Feild)
        
        key3Feild.placeholder = "Keyword 3";
        key3Feild.borderStyle = UITextBorderStyle.RoundedRect
        alertView.addSubview(key3Feild)
        
        var alert = UIAlertView(title: "Create New Task", message: "Enter Task Information", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Create")
        alert.setValue(alertView, forKey: "accessoryView")
        alert.show()
    }
    
    var swiftBlogs = [" "]
    var storyInterests = ["/Apollo/kirkuk-new", "/Apollo/isis", "/Apollo/bangladesh"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        
        face = Face(delegate: self, host: forwarderIP, port: forwarderPort)
        face.open()
    }
    
    func getStories () {
        var interest = Interest()
        interest.name = Name(url: storiesInterest)!
        interest.setInterestLifetime(1000)
        interest.setMustBeFresh()
        self.face.expressInterest(interest, onData: { [unowned self] in self.onStoriesResponse($0, d0: $1) }, onTimeout: { [unowned self] in self.onStoriesTimeout($0) })
    }
    
    // MARK: UIAlertViewDelegate Methods
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex) {
        case 1:
            var createStoryInterest = createStoryPrefix + self.storyFeild.text + createStorySeperator + self.key1Feild.text + createStorySeperator + self.key2Feild.text + createStorySeperator + self.key3Feild.text
            println(createStoryInterest)

            var interest = Interest()
            interest.name = Name(url: createStoryInterest)!
            interest.setInterestLifetime(1000)
            interest.setMustBeFresh()
            self.face.expressInterest(interest, onData: { [unowned self] in self.onCreateStoryResponse($0, d0: $1) }, onTimeout: { [unowned self] in self.onCreateStoryTimeout($0) })
        default:
            println("other")
        }
    }
    
    private func onCreateStoryResponse(i0: Interest, d0: Data) {
        println("Info: CreateStory - response for " + i0.name.toUri())
    }
    
    private func onCreateStoryTimeout(i0: Interest) {
        println("Error: CreateStory - timeout for " + i0.name.toUri())
    }
    
    private func onStoriesResponse(i0: Interest, d0: Data) {
        println("Info: Stories - response for " + i0.name.toUri())
        var a = d0.getContent()
        var list = NSString(bytes: a, length: a.count, encoding: NSUTF8StringEncoding)
        var stories = list?.componentsSeparatedByString("%%")
        
        swiftBlogs.removeAll(keepCapacity: true)
        for story in stories as! [String] {
            swiftBlogs.append(story)
        }
        println(swiftBlogs)
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    private func onStoriesTimeout(i0: Interest) {
        println("Error: Stories - timeout for " + i0.name.toUri())
    }

    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("StoryDetailSegue", sender: tableView)

    }
    
    // Move to next view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "StoryDetailSegue" {
            if let destinationVC = segue.destinationViewController as? StoryDetailViewController{
                let indexPath = self.tableView.indexPathForSelectedRow()?.row
                var destinationTitle = self.swiftBlogs[indexPath!]
                destinationVC.title = destinationTitle
                destinationVC.selectedStory = destinationTitle
                destinationVC.storyInterest = "/Apollo/" + self.swiftBlogs[indexPath!];
            }
            
        }
    }
    
    // Face Delegate Functions
    func onOpen() {
        println("Info: NDN Open.")
        getStories()
    }
    
    func onClose() {
        println("Info: NDN Close.")
    }
    
    func onError(reason: String) {
        println("Error: NDN - " + reason)
    }
}

