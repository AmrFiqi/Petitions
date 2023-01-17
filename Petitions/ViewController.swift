//
//  ViewController.swift
//  Petitions
//
//  Created by Amr El-Fiqi on 10/01/2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filtered = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Petitions"
        
        // Create credits button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(credits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filteredSearch))
        // Select the json to show based on bar button item
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Get the data from the url and parse it
            [weak self] in
            if let url = URL(string: urlString){
                if let data =  try? Data(contentsOf: url){
                    self?.parse(data)
                    return
                }
            }
            self?.showError()
        }
    }
    
    // decode the json and make it readable
    func parse(_ json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filtered = petitions
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let filter = filtered[indexPath.row]
        cell.textLabel?.text = filter.title
        cell.detailTextLabel?.text = filter.body
        return cell
    }
    
    // Show our detailViewController when selecting a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filtered[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Show error when unable to load data
    func showError(){
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Error", message: "There was an error showing the feed; Please check your internet then try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
        
    }
    
    // Credits
    @objc func credits(){
        let ac = UIAlertController(title: "Credits", message: "This data comes from the \"We The People\" API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    // Enter search words
    @objc func filteredSearch(){
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchWord = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(searchWord)
        present(ac, animated: true)
    }
    
    // Submit search word
    func submit(_ answer: String){
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if answer  == "" {
                self?.filtered = self!.petitions
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error, Not found", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac,animated: true)
                }
                
            }
            else{
                self?.filtered = self!.petitions.filter({ petition in
                    petition.body.contains(answer) || petition.title.contains(answer)
                })
            }
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
                
            }
            
        }
        
    }
}

