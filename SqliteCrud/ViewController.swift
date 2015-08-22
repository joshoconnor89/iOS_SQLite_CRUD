//
//  ViewController.swift
//  SqliteCrud
//
//  Created by Kristian Secor on 4/1/15.
//  Copyright (c) 2015 Kristian Secor. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
  
    
    var databasePath = NSString()
    
   var defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var position: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the path to the db
        //File Manager
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)
        println(dirPaths)
        let docsDir = dirPaths[0] as! String
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")
        if !filemgr.fileExistsAtPath(databasePath as String){
            //if no, we need to create the db
            let contactDB = FMDatabase(path:databasePath as! String)
            if contactDB == nil  {
                println("Error: \(contactDB.lastErrorMessage())")
            }
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,PHONE TEXT,EMAIL TEXT,POSITION TEXT )"
            if !contactDB.executeStatements(sql_stmt) {
                println("Error: \(contactDB.lastErrorMessage())")
                }
            contactDB.close()
            }//closes out the condition if !filemgr
            else
            {
        println("Error: \(contactDB.lastErrorMessage())")
            }
            
        }

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateRecord(sender: AnyObject) {
        if let idToEdit = defaults.stringForKey("IDtoEdit")
        {
        let contactDB = FMDatabase(path:databasePath as! String)
        if  contactDB.open() {
            let updateSql = "Update CONTACTS set NAME = '\(name.text)' ,PHONE = '\(phone.text)',EMAIL='\(email.text)',POSITION = '\(position.text)' where ID = '\(idToEdit)'";
            let result = contactDB.executeUpdate(updateSql, withArgumentsInArray:nil)
            if !result {
                name.text = "Failed to Update"
                println("Error: \(contactDB.lastErrorMessage())")
                phone.text = ""
                email.text = ""
                position.text = ""
            }
            else
            {
                let alertView = UIAlertController(title: "Record Updated", message: "Your code is awesome!", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
            }
        }
        }
    }
        
    @IBAction func deleteRecord(sender: AnyObject) {
        if let idToEdit = defaults.stringForKey("IDtoEdit")
        {
            let contactDB = FMDatabase(path:databasePath as! String)
            if  contactDB.open() {
                let updateSql = "Delete from Contacts where ID = '\(idToEdit)'";
                let result = contactDB.executeUpdate(updateSql, withArgumentsInArray:nil)
                
                
                if !result {
                    let alertView = UIAlertController(title: "Delete Failed", message: "Your code is disgraceful!", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alertView, animated: true, completion: nil)
                }
                else
                {
                    let alertView = UIAlertController(title: "Record Deleted", message: "Your code is awesome!", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alertView, animated: true, completion: nil)
                    name.text = ""
                    phone.text = ""
                    email.text = ""
                    position.text = ""
                }
            }
        }

        
        
        
    }
    @IBAction func saveData(sender: AnyObject) {
        let contactDB = FMDatabase(path:databasePath as! String)
        if  contactDB.open() {
        let insertSql = "Insert into CONTACTS (NAME,PHONE,EMAIL,POSITION) VALUES ('\(name.text)','\(phone.text)','\(email.text)','\(position.text)')"
        let result = contactDB.executeUpdate(insertSql, withArgumentsInArray:nil)
            if !result {
                name.text = "Failed to add Contact"
                println("Error: \(contactDB.lastErrorMessage())")
                phone.text = ""
                email.text = ""
                position.text = ""
            }
            else
            {
                name.text = "Contact Added"
                phone.text = ""
                email.text = ""
                position.text = ""
            }      
            
        }//closed if contact open
        else
        {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }//closes method

    @IBAction func searchContact(sender: AnyObject) {
        let contactDB = FMDatabase(path:databasePath as! String)
        if  contactDB.open() {
            let searchSql = "Select ID,NAME,PHONE,EMAIL,POSITION from CONTACTS where NAME = '\(name.text)'"
            let results:FMResultSet? = contactDB.executeQuery(searchSql, withArgumentsInArray:nil)

            if results?.next() == true {

                name.text = results?.stringForColumn("NAME")
                phone.text = results?.stringForColumn("PHONE")
                email.text = results?.stringForColumn("EMAIL")
                position.text = results?.stringForColumn("POSITION")
                defaults.setObject(results?.stringForColumn("ID"), forKey: "IDtoEdit")
            }
            else
            {
                phone.text = ""
                email.text = ""
                position.text = ""
            }
            contactDB.close()
        }

        }
   
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    
    
}

