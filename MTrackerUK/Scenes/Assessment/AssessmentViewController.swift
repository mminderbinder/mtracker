//
//  AssessmentViewController.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-22.
//
import UIKit

class AssessmentViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    private var viewModel: AssessmentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    
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
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.layer.cornerRadius = 8
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
    
        footerView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 24),
            submitButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        tableView.tableFooterView = footerView
        
        submitButton.addTarget(self, action: #selector(submitButtonTouched), for: .touchUpInside)
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
    
    
    @objc private func submitButtonTouched() {
        guard let viewModel = viewModel else { return }
        
        if !viewModel.allQuestionsAnswered() {
            showAlert()
            return
        }
        if viewModel.saveResults() {
            performSegue(withIdentifier: "ShowDetailedResultsSegue", sender: self)
        } else {
            print("Failed to save results")
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Not Complete", message: "Please complete all questions", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedResultsSegue" {
            if let detailedResultsVC = segue.destination as? DetailedResultsViewController,
               let viewModel = viewModel,
               let resultId = viewModel.getResultId {
                detailedResultsVC.configureWithResultId(resultId)
            }
        }
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
            let savedAnswer = viewModel?.answerForQuestion(withId: question.id)
            
            cell.configure(with: question, index: indexPath.row, selectedAnswer: savedAnswer)
            
            cell.valueChanged = { [weak self] questionIndex, value in
                self?.viewModel?.updateAnswer(forQuestionIndex: questionIndex, value: Int64(value))
            }
        }
        return cell
    }
}
