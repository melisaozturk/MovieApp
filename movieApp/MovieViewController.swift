//
//  MovieViewController.swift
//  movieApp
//
//  Created by Melisa on 10.08.2018.
//  Copyright © 2018 Melisa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage


class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var moviesArray = [[String:AnyObject]]() //Sözlük için array
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        
       
        
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?page=1&include_video=false&include_adult=false&sort_by=popularity.desc&language=en-US&api_key=45a4fdf097060d7804046ad3fe9098c3").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.moviesArray = resData as! [[String:AnyObject]]
                }
                if self.moviesArray.count > 0 {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count//moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        var dict = moviesArray[indexPath.row]
        cell.lblMovieName.text = dict["title"] as? String
        
        if let imageUrl = dict["poster_path"] as? String{
            Alamofire.request( "http://image.tmdb.org/t/p/w500//" + imageUrl).responseImage(completionHandler: {(response) in
                print(response, "\n\n")
                
                if let image = response.result.value{
                    DispatchQueue.main.async {
                        cell.imgMovie.image = image
                    }
                }
                })
        }
       
        
        return cell
    }
    
}
