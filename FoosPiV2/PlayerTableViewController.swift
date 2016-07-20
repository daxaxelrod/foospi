//
//  PlayerTableViewController.swift
//  FoosPiV2
//
//  Created by David Axelrod on 7/19/16.
//  Copyright © 2016 David Axelrod. All rights reserved.
//

import UIKit

class PlayerTableViewController: UITableViewController {
    
    
    var players = [Player]()
    var results: NSDictionary = [:]
    
    //temp
    let player1 = Player(name: "Andres", wins: 1289371293, losses: -13)
    let player2 = Player(name: "David", wins:10,losses: 123)
    let player3 = Player(name: "Max", wins:123,losses: 10)
    let player4  = Player(name: "Adelina", wins: 2, losses: 1)
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        //players += [player1, player2, player3, player4]
        
        let url = "http://192.168.2.111:8000/api/v1/goals/"
        
        let myUrl = NSURL(string: url)
        
        //create request
        
        let request = NSMutableURLRequest(URL: myUrl!)
        
        //execute
        let task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration()).dataTaskWithRequest(request) {
            
            data, response, error in
            
            if error != nil {
                NSLog("error=\(error)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("______Response_______")
            NSLog(responseString! as String)
            
            //covert to dictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    //
                    //                    self.results = convertedJsonIntoDict
                    // Print out dictionary
                    NSLog( "%@", convertedJsonIntoDict );
                    self.results = convertedJsonIntoDict
                    // Get value by key                                 as! NSArray! //as? [String : AnyObject]
                    if let results = convertedJsonIntoDict["results"] {
                        NSLog("+++++++++")
                        NSLog("+++++++++")
                        
                        var tempArray: [Player] = []
                        for i in 0 ..< results.count {
                            NSLog("________________")
                            //let individualPlayer: NSDictionary = results[i]
//                            print(results[i]["id"]!)
                        
                            if let name = results[i]["name"]!, wins = results[i]["wins"]!, losses = results[i]["losses"]! {
                                print("________")
                                let person = Player(name: name as! String, wins: wins as! Int, losses: losses as! Int)
                                tempArray.append(person)
                                
//                              let waka: AnyClass! = object_getClass(person)
//                              print(waka)
                                
                            }
                        }
                        
                        self.players += tempArray
                        print(self.players)
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

        return self.players.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PlayerTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlayerTableViewCell
        
        // Configure the cell...
        let player = players[indexPath.row]
        cell.playerName.text = player.name
        cell.winsAndLosses.text = "Wins: \(player.wins)  Losses: \(player.losses)"

        return cell
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
