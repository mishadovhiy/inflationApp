//
//  UITableViewDataSource_ResultViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 30.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = historyResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        cell.cellValue.text = "$\(row.value)"
        cell.cellYear.text = row.year
        //cell.countLabel.text = "\(row.count)."
        cell.progressBar.progress = progressBarSetup(n: row.value)
        
        return cell
        
    }
    
}

