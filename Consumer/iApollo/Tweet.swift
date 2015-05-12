//
//  Tweet.swift
//  InfoMaxApollo
//
//  Created by Shreya Garg on 4/19/15.
//  Copyright (c) 2015 akash_kapoor. All rights reserved.
//

import Foundation

class Tweet{
    var userName = "sgarg"
    var tweet = "hello hi jai mata di"
    var time = "5pm"
    var suffix = ""
    var imageName = "pic"
    
    init(userName: String, tweet: String, time: String, imageName: String, suffix: String){
        self.imageName = imageName
        self.time = time
        self.tweet = tweet
        self.userName =  userName
        self.suffix = suffix
    }
    


}