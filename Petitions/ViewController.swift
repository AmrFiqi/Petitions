//
//  ViewController.swift
//  Petitions
//
//  Created by Amr El-Fiqi on 10/01/2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create credits button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(credits))
        
        // Select the json to show based on bar button item
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // Get the data from the url and parse it
        if let url = URL(string: urlString){
            if let data =  try? Data(contentsOf: url){
                parse(data)
                return
            }
        }
            showError()
    }
    // decode the json and make it readable
    func parse(_ json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
                petitions = jsonPetitions.results
                tableView.reloadData()
            }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    // Show our detailViewController when selecting a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Show error when unable to load data
    func showError(){
        let ac = UIAlertController(title: "Error", message: "There was an error showing the feed; Please check your internet then try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    // Credits
    @objc func credits(){
        let ac = UIAlertController(title: "Credits", message: "This data comes from the \"We The People\" API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}

