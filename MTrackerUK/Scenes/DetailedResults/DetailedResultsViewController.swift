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
    
    @IBOutlet weak var deleteButton: UIButton!
    
    private var viewModel: DetailedResultsViewModel?
    
    private var shouldHideUIComponents: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 44
        
        if shouldHideUIComponents {
            navigationItem.hidesBackButton = true
            deleteButton.isHidden = true
        }
        
        if viewModel != nil {
            loadData()
        }
    }
    
    func configureWithResultId(_ resultId: Int64, shouldHideUIComponents: Bool = false) {
       
        self.viewModel = DetailedResultsViewModel(resultId: resultId)
        self.shouldHideUIComponents = shouldHideUIComponents
        
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
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = "N/A"
        }
        
        scoreLabel.text = viewModel.getScore() ?? "N/A"
        severityLabel.text = viewModel.getImpairmentLevel() ?? "N/A"
        
        tableView.reloadData()
    }
    
    @IBAction func onDeleteButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Delete Result",
            message: "Are you sure you want to delete this result?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self, let viewModel = self.viewModel else { return }
            
            _ = viewModel.deleteResult()
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
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
