//
//  ViewController.swift
//  Tumblr
//
//  Created by Kritarth Upadhyay on 7/17/16.
//  Copyright (c) 2016 walmart. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var dbUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var DATA = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            networkLabel.hidden = true
        } else {
            print("Internet connection FAILED")
            networkLabel.hidden = false
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string:dbUrl)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                            if let responseDictionary = try? NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                                                                                //NSLog("response: \(responseDictionary)")
                                                                                //self.DATA = responseDictionary["results"]
                                                                                if let element = responseDictionary!["results"] {
                                                                                    self.DATA = element as! NSArray
                                                                                    //NSLog("response: \(self.DATA)")
                                                                                    self.tableView.reloadData()
                                                                                }
                                                                            }
                                                                        }
        });
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("response: \(DATA.count)")
        if let DATA = DATA as? NSArray {
            return DATA.count;
        } else {
            return 0;
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as? MovieCell
        let movie = DATA[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell!.titleLabel!.text = title
        cell?.overviewLabel.text = overview
        cell?.posterView.setImageWithURL(imageUrl!)
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let movieDescriptionViewController = segue.destinationViewController as! MovieDescriptionViewController
        let index = tableView.indexPathForSelectedRow
        let movie = DATA[index!.row]
        movieDescriptionViewController.movie = movie as! NSDictionary
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            networkLabel.hidden = true
        } else {
            print("Internet connection FAILED")
            networkLabel.hidden = false
        }
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let url = NSURL(string:dbUrl)
        let request = NSURLRequest(URL: url!)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in if let data = dataOrNil {
            
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let responseDictionary = try? NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    
                    if let element = responseDictionary!["results"] {
                        
                        self.DATA = element as! NSArray
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        
                    }
                }
            }
        });
        task.resume()
    }
    
    
}
