//
//  ResultsViewController.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-27.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ResultsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.retrieveResults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedResultsSegue",
           let detailedResultsVC = segue.destination as? DetailedResultsViewController,
           let resultId = sender as? Int64 {
            detailedResultsVC.configureWithResultId(resultId)
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let result = viewModel.result(at: indexPath.row)
        
        if let resultId = result.id {
            performSegue(withIdentifier: "ShowDetailedResultsSegue", sender: resultId)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as? ResultsTableViewCell else {
            return UITableViewCell()
        }
        
        let result = viewModel.result(at: indexPath.row)
        
        cell.assessmentLabel.text = viewModel.retrieveAssessmentName(result.assessmentId)
        cell.dateLabel.text = viewModel.retrieveDate(result.dateTaken)
        cell.severityLabel.text = result.impairmentCategory
        
        return cell
    }
}
