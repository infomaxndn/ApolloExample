//
//  CustomCell.swift
//  InfoMaxApollo
//
//  Created by Shreya Garg on 4/19/15.
//  Copyright (c) 2015 akash_kapoor. All rights reserved.
//

import UIKit
import QuartzCore

class CustomCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func setCell(userName: String, tweet: String, time: String, imageName: String){
        dispatch_async(dispatch_get_main_queue(),{
            //let url = NSURL(string: "https://pbs.twimg.com/profile_images/1147941384/Capture.PNG")
            //let data = NSData(contentsOfURL: url!)
            
            //self.profileImage.image = UIImage(data: data!)
            self.profileImage.image = UIImage(named: "dummy.png")
            self.profileImage.clipsToBounds = true
            self.profileImage.layer.cornerRadius = 20
            self.profileImage.layer.borderWidth = 2.0
            self.profileImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.profileImage.layer.backgroundColor = UIColor.clearColor().CGColor
            self.profileImage.layer.masksToBounds = true
            
        } )
        

        self.time.text = time
        self.tweet.text = tweet
        self.username.text =  userName
    }
}
