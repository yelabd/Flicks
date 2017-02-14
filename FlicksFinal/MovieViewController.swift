//
//  MovieViewController.swift
//  FlicksFinal
//
//  Created by Youssef Elabd on 2/6/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController {
    
     var movieInfo : Movie?

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var backPosterView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.bounds.height*1.5
        )
        
        infoView.layer.cornerRadius = 20
        ratingView.layer.cornerRadius = 12
        
    
//        UIApplication.shared.statusBarStyle = .lightContent

        let title = movieInfo!.title
        let overview = movieInfo!.overview
        let posterPath = movieInfo!.posterPath
        let ratingDouble = movieInfo!.rating
        //        let ratingDouble = Double(ratingString!)
        
        if (ratingDouble < 7 && ratingDouble > 5.5){
            let yellowColor = UIColor(red: 255/255.0, green: 223/255.0, blue: 0/255.0, alpha: 1.0)
            self.ratingView.backgroundColor = yellowColor
        }else if(ratingDouble <= 5.5){
            self.ratingView.backgroundColor = UIColor.red
        }
        
        let baseURL = "https://image.tmdb.org/t/p/w45"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        print("Poster path  \(baseURL)\(posterPath)")
        
        titleLabel.text = title
        //descLabel.text = overview
        ratingLabel.text = "\(ratingDouble)"
        descTextView.text = overview
        posterView.setImageWith(imageURL as! URL)
//        backPosterView.setImageWith(imageURL as! URL)

        let baseHighURL = "https://image.tmdb.org/t/p/original"
        
        let imageHighURL = NSURL(string: baseHighURL + posterPath)
        
        posterView.setImageWith(imageHighURL as! URL)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
