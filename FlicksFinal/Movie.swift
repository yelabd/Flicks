//
//  Movie.swift
//  FlicksFinal
//
//  Created by Youssef Elabd on 2/12/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    
    var title: String = ""
    var overview: String = ""
    var posterPath: String = ""
    var date: String = ""
    var rating: Double = 0.0
    var id: Int = 0;
    var runtime: Int = 0;
    
    init(json : JSON){
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        posterPath = json["poster_path"].stringValue
        date = json["release_date"].stringValue
        rating = json["vote_average"].doubleValue
        id = json["id"].intValue
        runtime = json["runtime"].intValue
        





        
        
    }
    
    
    

}
