//
//  DetailsViewController.swift
//  iTunesSearch
//
//  Created by Davide Fucci on 20/10/14.
//  Copyright (c) 2014 Davide Fucci. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, APIControllerProtocol {
    lazy var api : APIController = APIController(delegate: self)
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    
    var tracks = [Track]()
    
    var album: Album?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)))
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playLabel.text = "▶️"
        
        return cell
    }
    
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(resultsArr)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
