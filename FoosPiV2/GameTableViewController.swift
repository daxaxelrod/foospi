//
//  GameTableViewController.swift
//  FoosPiV2
//
//  Created by David Axelrod on 7/20/16.
//  Copyright © 2016 David Axelrod. All rights reserved.
//

import UIKit


class GameTableViewController: UITableViewController {
    
    var games = [Game]()
    var resultsGames: NSDictionary = [:]
    
//    let game1 = Game(gameID: 1, winner: "Max", duration: 12.4)
//    let game2 = Game(gameID: 2, winner: "David", duration: 11232.4)
//    let game3 = Game(gameID: 3, winner: "Andres", duration: 1211.4)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        //games += [game1,game2,game3]
        
        //url
        let url = "http://192.168.2.111:8000/api/v1/goals/games"
        let myUrl = NSURL(string: url)
        
        //create request
        
        let request = NSMutableURLRequest(URL: myUrl!)
        
        //execute
        let task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration()).dataTaskWithRequest(request) {
            
            data, response, error in
            
            if error != nil {
                NSLog("error=\(error)")
                return
            }
            
            let responseString: NSString? = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            
            NSLog("______Response_______")
            NSLog(responseString as! String)
            
            //covert to dictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    //
                    //                    self.results = convertedJsonIntoDict
                    // Print out dictionary
                    NSLog( "%@", convertedJsonIntoDict );
                    self.resultsGames = convertedJsonIntoDict
                    // Get value by key                                 as! NSArray! //as? [String : AnyObject]
                    if let results = convertedJsonIntoDict["results"] {
                        NSLog("+++++++++")
                        NSLog("+++++++++")
                        
                        var tempArray: [Game] = []
                        for i in 0 ..< results.count {
                            
                            if let id: Int = results[i]["id"]! as? Int, winner: String = results[i]["winner"]! as? String, duration: String = results[i]["duration"]! as? String{
//                                print("id: \(id), winner: \(winner) duration: \(duration)")
                                let numberFormatter = NSNumberFormatter()
                                let number = numberFormatter.numberFromString(duration)
                                let floatVal = number!.floatValue
                                
                                let game = Game(gameID: id, winner: winner, duration: floatVal)
                                tempArray.append(game)
                                
                                //                              let waka: AnyClass! = object_getClass(person)
                                //                              print(waka)
                                
                            }
                        }
                        
                        self.games += tempArray
                        self.games = self.games.reverse()
                        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                            self.tableView.reloadData()
                            NSLog("%@", [NSThread.currentThread()])
                            //has to execute on the main thread
                            
                        }
                        
                        
                        
                    } else {
                        NSLog("Bad Optional")
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView.reloadData()
            
        })
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.games.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "Check Your Internet Connection"
            emptyLabel.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }
        
        return games.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GameTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GameTableViewCell
        
        let game = games[indexPath.row]
        cell.gameID.text = "\(game.gameID)"
        cell.winner.text = game.winner
        cell.duration.text = "\(game.duration) (in s)"

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        
        vw.backgroundColor = UIColor.blackColor()
        //creation and spacing
        let labelGameNum = UILabel(frame: CGRectMake(self.view.bounds.size.width/20, 0, self.view.bounds.size.width/3, 10))
        let labelWinner = UILabel(frame: CGRectMake(self.view.bounds.size.width*1/3, 0, self.view.bounds.size.width/3, 10))
        let labelDuration = UILabel(frame: CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 10))
        
        //coloring
        labelGameNum.textColor = UIColor.blueColor()
        labelGameNum.text = "Game#"
        labelWinner.textColor = UIColor.blueColor()
        labelWinner.text = "Winner"
        labelDuration.textColor = UIColor.blueColor()
        labelDuration.text = "Duration"
        
        //sizeing
        labelGameNum.sizeToFit()
        labelWinner.sizeToFit()
        labelDuration.sizeToFit()
        
        
        vw.addSubview(labelGameNum)
        vw.addSubview(labelWinner) //problem child
        vw.addSubview(labelDuration)
        
        return vw
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
