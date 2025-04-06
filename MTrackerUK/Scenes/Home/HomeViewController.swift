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

        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.retrieveAssessments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAssessmentSegue",
           let assessmentVC = segue.destination as? AssessmentViewController,
           let assessment = sender as? Assessment {
            assessmentVC.configureWithAssessment(assessment)
        }
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
        cell.delegate = self
        return cell
    }
}

extension HomeViewController : HomeTableViewCellDelegate {
    func didTouchStartButton(for assessment: Assessment) {
        performSegue(withIdentifier: "ShowAssessmentSegue", sender: assessment)
    }
}
