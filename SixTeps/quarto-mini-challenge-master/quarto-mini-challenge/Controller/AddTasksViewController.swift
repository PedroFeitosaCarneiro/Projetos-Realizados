//
//  AddTasksViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class AddTasksViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var taskNameTF: UITextField!
    @IBOutlet weak var taskCell: UIImageView!
    @IBOutlet weak var leftCharsLabel: UILabel!
    
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Properties
    private let taskBuilder = TaskConcreteBuilder()
    var task: Task?
    public var callBackClosure: (() -> Void)?
    private var maxLengthOfTextField: Int = 35
    
    public weak var tasksViewControllerDelegate: TasksViewControllerDelegate?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameTF.delegate = self
        self.leftCharsLabel.text = "\(maxLengthOfTextField)"
        self.setBackgroundView()
        self.setBlurEffect()
        
        setSegmentedControl(segmentedControl: self.prioritySegmentedControl, enumType: PriorityType.self)
        setSegmentedControl(segmentedControl: self.timeSegmentedControl, enumType: DifficultyType.self)
        setSegmentedControl(segmentedControl: self.categorySegmentedControl, enumType: CategoryTaskType.self)
        
        
        
        if let task = self.task {
            self.taskNameTF.text = task.name
            self.prioritySegmentedControl.selectedSegmentIndex = Int(task.id_priority.rawValue)
            self.timeSegmentedControl.selectedSegmentIndex = Int(task.id_difficulty.rawValue)
            self.categorySegmentedControl.selectedSegmentIndex = Int(task.id_category.rawValue)
        }
        
        self.updateLeftCharsLabel()
        self.updateTaskCell()
    }
    
    //MARK: - Methods
    /// Mehtod to create action sheet
    /// - Parameters:
    ///   - title: title to be exposed
    ///   - enumType: enum to be iterated and create the option buttons
    ///   - saveCompletion: method to save the option chosen
    /// - Returns: the action sheet set up
    /// - Author: Bernardo
//    private func createActionSheet<T : RawRepresentable & EnumTypesProtocol>(title: String, enumType: T.Type, saveCompletion: @escaping (Int16)->Void) -> UIAlertController {
//        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
//
//        for caseEnum in enumType.allCases {
//            let action = UIAlertAction(title: caseEnum.getName, style: .default) { (_) in
//                saveCompletion(caseEnum.rawValue as! Int16)
//            }
//            actionSheet.addAction(action)
//        }
//
//        return actionSheet
//    }
    
    private func setSegmentedControl<T: RawRepresentable & EnumTypesProtocol>(segmentedControl: UISegmentedControl, enumType: T.Type) {
        segmentedControl.removeAllSegments()
        segmentedControl.addTarget(self, action: #selector(changeSelectionOfSegmentedControl(_:)), for: .valueChanged)
        for caseEnum in enumType.allCases {
            segmentedControl.insertSegment(withTitle: caseEnum.getName, at: Int(caseEnum.rawValue as! Int16), animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setBackgroundView() {
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 10.0
        backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
        backgroundView.layer.shouldRasterize = false
    }
    
    private func setBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.85
        blurEffectView.frame = self.view.bounds
        
        self.view.insertSubview(blurEffectView, belowSubview: self.backgroundView)
        
    }
    
    private func updateTaskCell() {
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        self.updateCategoryImage(deviceName)
        self.updateFontOfTextField()
    }
    
    private func updateCategoryImage(_ deviceName: String) {
        switch Int16(categorySegmentedControl.selectedSegmentIndex) {
            case CategoryTaskType.Health.rawValue:
                self.taskCell.image = UIImage(named: "health-cell-\(deviceName)")
            case CategoryTaskType.Others.rawValue:
                self.taskCell.image = UIImage(named: "others-cell-\(deviceName)")
            case CategoryTaskType.Studies.rawValue:
                self.taskCell.image = UIImage(named: "study-cell-\(deviceName)")
            case CategoryTaskType.Recreation.rawValue:
                self.taskCell.image = UIImage(named: "recreation-cell-\(deviceName)")
            case CategoryTaskType.Work.rawValue:
                self.taskCell.image = UIImage(named: "work-cell-\(deviceName)")
            default:
                break
        }
    }
    
    private func updateFontOfTextField() {
        switch Int16(prioritySegmentedControl.selectedSegmentIndex) {
            case PriorityType.High.rawValue:
                self.taskNameTF.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 18)
            case PriorityType.Medium.rawValue:
                self.taskNameTF.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 18)
            case PriorityType.Low.rawValue:
                self.taskNameTF.font = UIFont(name: FontName.SFProDisplayThin.rawValue, size: 18)
            default:
                break
        }
        
    }
    
    /// Method to save the priority
    /// - Parameter priorityID: Priority enum raw value
    /// - Author: Bernardo
    private func savePriority(priorityID: Int16) {
        guard let priority = PriorityType(rawValue: Int16(priorityID)) else { return }
        
        if var task = self.task {
            task.setPriority(priority: priority)
             self.task = task
        } else {
            self.taskBuilder.producePriority(priority)
        }
    }
    
    /// Method to save the difficulty
    /// - Parameter difficultyID: difficulty enum raw value
    /// - Author: Bernardo
    private func saveDifficulty(difficultyID: Int16) {
        guard let difficulty = DifficultyType(rawValue: Int16(difficultyID)) else { return }
        
        if var task = self.task {
            task.setDifficulty(difficulty: difficulty)
             self.task = task
        } else {
            self.taskBuilder.produceDifficulty(difficulty)
        }
    }
    
    /// Method to save the category
    /// - Parameter categoryID: category enum raw value
    /// - Author: Bernardo
    private func saveCategory(categoryID: Int16) {
        guard let category = CategoryTaskType(rawValue: Int16(categoryID)) else { return }
        
        if var task = self.task {
            task.setCategory(category: category)
            self.task = task
        } else {
            self.taskBuilder.produceCategory(category)
        }
    }
    
    //Delegate method to make keyboard disappear on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.taskNameTF.resignFirstResponder()
        return true
    }
    
    //Delegate method to limit the characters in the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= self.maxLengthOfTextField
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateLeftCharsLabel()
    }
    
    private func updateLeftCharsLabel() {
        guard let taskNameText = self.taskNameTF.text else {return}
        let remainingChars = self.maxLengthOfTextField - taskNameText.count
        self.leftCharsLabel.text = "\(remainingChars)"
        
        if remainingChars <= 5 {
            leftCharsLabel.textColor = .red
        } else {
            leftCharsLabel.textColor = .black
        }
    }
    
    
    //MARK: - IBActions
    @objc func changeSelectionOfSegmentedControl(_ sender: UISegmentedControl) {
        switch sender {
            case prioritySegmentedControl:
                self.updateFontOfTextField()
            case categorySegmentedControl:
                self.updateCategoryImage(AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size))
            default:
                break
        }
    }
    
    @IBAction func didTapOnAddTaskButton(_ sender: Any) {
        self.savePriority(priorityID: Int16(prioritySegmentedControl.selectedSegmentIndex))
        self.saveCategory(categoryID: Int16(categorySegmentedControl.selectedSegmentIndex))
        self.saveDifficulty(difficultyID: Int16(timeSegmentedControl.selectedSegmentIndex))
        do {
            if var task = self.task {
                try task.setName(name: self.taskNameTF.text)
                self.tasksViewControllerDelegate?.addTask(task: task)
            } else {
                try self.taskBuilder.produceName(self.taskNameTF.text)
                let task = self.taskBuilder.build()
                self.tasksViewControllerDelegate?.addTask(task: task)
            }
            callBackClosure?()
            self.dismiss(animated: true) {
//                self.tasksViewControllerDelegate?.moveRows()
            }
        } catch  TaskError.noValidName {
            print("Nome mt longo")
            return
        } catch TaskError.emptyName {
            showSimpleErrorAlert(message: NSLocalizedString("cantEmpty", comment: ""))
            print("nome vazio")
            return
        } catch {
            print("fudeu")
            return
        }
    }
    
    @IBAction func didTapInsideOfView(_ sender: Any) {
        self.taskNameTF.resignFirstResponder()
    }
    
    @IBAction func didTapOutsideOfView(_ sender: Any) {
        callBackClosure?()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func showSimpleErrorAlert(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
