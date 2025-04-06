//
//  DetailedResultsViewController.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-22.
//

import UIKit

class DetailedResultsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var assessmentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var severityLabel: UILabel!
    
    private var viewModel: DetailedResultsViewModel?
    
    private var result: Result?
    
    private var resultId: Int64?
    
    private var scoreMap: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if viewModel != nil {
            loadData()
        }
    }
    
    func configureWithResultId(_ resultId: Int64) {
        self.viewModel = DetailedResultsViewModel(resultId: resultId)
        
        if isViewLoaded {
            loadData()
        }
    }
    
   private func loadData() {
       viewModel?.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
       viewModel?.loadData()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        assessmentLabel.text = viewModel.getAssessmentName() ?? "N/A"
        
        if let date = viewModel.getDateTaken() {
            let Formatter = DateFormatter()
            Formatter.dateStyle = .medium
            dateLabel.text = Formatter.string(from: date)
        } else {
            dateLabel.text = "N/A"
        }
        
        scoreLabel.text = viewModel.getScore() ?? "N/A"
        
        severityLabel.text = viewModel.getImpairmentLevel() ?? "N/A"
        
        tableView.reloadData()
    }
}

extension DetailedResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreInterpretationCell", for: indexPath) as? DetailedResultsTableViewCell,
              let scorePair = viewModel?.getScoreRangeAt(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.scoreLabel.text = scorePair.range
        cell.severityLabel.text = scorePair.category
        
        return cell
    }
}
