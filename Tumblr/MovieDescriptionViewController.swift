//
//  MovieDescriptionViewController.swift
//  Tumblr
//
//  Created by Kritarth Upadhyay on 7/17/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class MovieDescriptionViewController: UIViewController {

    var movie = NSDictionary();
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!

    let baseUrl = "http://image.tmdb.org/t/p/w500"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height)
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        

        moviePosterImageView.setImageWithURL(imageUrl!)
        movieTitleLabel.text = title
        movieDescriptionLabel.text = overview

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
