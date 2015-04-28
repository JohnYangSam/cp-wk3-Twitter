//
//  TimelineViewController.swift
//  Twitter
//
//  Created by John YS on 4/27/15.
//  Copyright (c) 2015 Silicon Valley Insight. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Instance variables
    var tweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        
        // UITableView automatic dimensions
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            
            if tweets != nil {
                self.tweets = tweets!
                self.tableView.reloadData()
            } else {
                // Handle the error here
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // SignOut/Logout Action
    @IBAction func onClickSignOut(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        User.currentUser?.logout()
    }
    
    @IBAction func onClickComposeTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    // TableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TweetViewCell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell") as! TweetViewCell
        
        let tweet:Tweet = tweets[indexPath.row]
        
        if let user:User = tweet.user {
            cell.profilePicture.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        }
        
        if let text:String = tweet.text {
            cell.tweetTextLabel.text = text
        }
        
        if let createdAtDate:NSDate = tweet.createdAtDate {
            // Get the current date
            var time = String(format: "%.0f", round(createdAtDate.timeIntervalSinceNow / 60 * -1))
            cell.hoursLabel.text = time + "h"
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
