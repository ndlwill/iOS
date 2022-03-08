//
//  TestTableViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2021/12/16.
//  Copyright © 2021 dzcx. All rights reserved.
//

import UIKit

final class TestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestTableViewController {
    // MARK: - Section (for table group)
    enum TestSection: Int, CaseIterable {
        case section1
        //case section2
        
        var title: String {
            switch self {
            case .section1:
                return "section1"
                /*
            case .section2:
                return "section2"
                 */
            }
        }
        
        var allRowCase: [CellRowRule] {
            switch self {
            case .section1:
                return Section1RowType.allCases
                /*
            case .section2:
                return Section2RowType.allCases
                 */
            }
        }
    }
    
    // MARK: - Section
    enum Section1RowType: CaseIterable, CellRowRule {
        case picker
        case editor
        case capture
        
        var title: String {
            switch self {
            case .picker:
                return "Picker"
            case .editor:
                return "Editor"
            case .capture:
                return "Capture"
            }
        }
        
        var controller: UIViewController {
            let style: UITableView.Style
            if #available(iOS 13.0, *) {
                style = .insetGrouped
            } else {
                style = .grouped
            }
            /*
            switch self {
            case .picker:
                return PickerConfigViewController(style: style)
            case .editor:
                return EditorConfigViewController(style: style)
            case .capture:
                return CaptureConfigViewController(style: style)
            }
             */
            return UIViewController()
        }
    }
    
}
