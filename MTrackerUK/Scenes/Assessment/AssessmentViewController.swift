//
//  AssessmentViewController.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-22.
//
import UIKit

class AssessmentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    private var viewModel: AssessmentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        setUpSubmitButton()
        
        loadUI()
        
        loadQuestions()
    }
    
    func configureWithAssessment(_ assessment: Assessment) {
        self.viewModel =  AssessmentViewModel(assessment: assessment)
    }
    
    private func setUpSubmitButton() {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        let submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x: 16, y: 20, width: footerView.frame.width - 32, height: 44)
        submitButton.layer.cornerRadius = 8
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)

        footerView.addSubview(submitButton)
        tableView.tableFooterView = footerView
    }
    
   private func loadUI() {
        guard let viewModel = viewModel else { return }
       
       titleLabel.text = viewModel.assessmentTitle
       instructionsLabel.text = viewModel.assessmentInstructions
    }
    
    private func loadQuestions() {
        viewModel?.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel?.retrieveQuestions()
    }
}

extension AssessmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? AssessmentTableViewCell
        else {
            return UITableViewCell()
        }
        if let question = viewModel?.question(at: indexPath.row) {
            cell.configure(with: question, index: indexPath.row)
            
            cell.valueChanged = { [weak self] questionIndex, value in
                self?.viewModel?.updateAnswer(forQuestionIndex: questionIndex, value: Int64(value))
            }
        }
        return cell
    }
}

extension AssessmentViewController: UITableViewDelegate {
}
