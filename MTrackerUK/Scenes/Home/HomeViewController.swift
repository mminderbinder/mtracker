//
//  HomeViewController.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-27.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HomeViewController loaded")
        
        tableView.dataSource = self
        tableView.delegate = self

        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.retrieveAssessments()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let assessment = viewModel.assessment(at: indexPath.row)
        
        cell.configure(with: assessment)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}
