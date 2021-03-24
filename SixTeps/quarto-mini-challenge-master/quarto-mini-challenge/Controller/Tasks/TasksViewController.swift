//
//  TasksViewController.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 01/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit
import StoreKit
import SwiftUI
import AVKit

protocol TasksViewControllerDelegate: class {
    func addTask(task: Task)
    func moveRows()
}

class TasksViewController: UIViewController {
    
    //Attributes
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var addTasksButton: UIButton!
    @IBOutlet weak var endTaskBlockButton: UIButton!
    @IBOutlet weak var endTaskBlockLabel: UILabel!
    let orderNearbyButton = UIButton(type: .system)
    let orderAllButton = UIButton(type: .system)
    
    private(set) var taskBlockBuilder: TaskBlockConcreteBuilder?
    internal var editionMode: Bool = false
    private var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(toggleEditionMode))
    
    private var noTasksLabel: UILabel = UILabel()
    private var noTasksBackground: UIImageView = UIImageView()
    
    var canClick:Bool = true
    var cellSpacingHeight: CGFloat = 30
    var tasksUncompleted = 6 {
        didSet {
            if tasksUncompleted > 5 {
                self.addTasksButton.isEnabled = false
            } else {
                self.addTasksButton.isEnabled = true
            }
        }
    }
    
    private(set) var taskBlock = TaskBlock(createNew: false)
    
    var rankingController: RankingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundWhite")
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.setupEndTaskBlockItems()
        self.tasksTableView.dataSource = self
        self.tasksTableView.delegate = self
        self.taskBlock = TaskBlock(createNew: false)
        self.setTasksTableView(deviceName: AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        
        self.tasksUncompleted = self.taskBlock.getAmountOfUncompletedTasks()
        self.setAddTasksButton()
        self.setupNavBarItems()
    }
    
    /// This functions changes the view to add a task
    /// - Parameter sender: The Add Task Button
    /// - Author: Antônio Carlos
    @IBAction func didTapOnAddTaskButton(_ sender: Any) {
        self.toggleEditionMode()
        self.taskBlockBuilder = TaskBlockConcreteBuilder()
        self.tasksTableView.reloadData()
    }
    
    @IBAction func didTapOnEndTaskButton(_ sender: Any) {
        self.taskBlockBuilder?.buildTaskBlock()
        self.taskBlock = TaskBlock(createNew: false)
        self.toggleEditionMode()
    }
    
    @objc private func toggleEditionMode() {
        self.editionMode.toggle()
        self.addTasksButton.isHidden = self.editionMode
        self.navigationController?.navigationBar.prefersLargeTitles = !self.editionMode
        self.endTaskBlockButton.isHidden = !self.editionMode
        self.endTaskBlockLabel.isHidden = !self.editionMode
//        self.tasksTableView.allowsSelection = self.editionMode
        
        
        if editionMode {
            self.noTasksLabel.removeFromSuperview()
            self.noTasksBackground.removeFromSuperview()
            self.tasksTableView.isHidden = false
            self.navigationController?.navigationBar.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(toggleEditionMode)), animated: true)
            
        } else {
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.setupNavBarItems()
            self.navigationController?.navigationItem.rightBarButtonItem = nil
            self.tasksTableView.isEditing = false
            self.tasksTableView.allowsSelectionDuringEditing = false
            self.tasksTableView.dragInteractionEnabled = false
        }
        self.setTasksTableView(deviceName: AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size))
        self.tasksTableView.reloadData()
        if !editionMode {
            self.createOnboardingSwipeHint()
        }
    }
    
    private func createOnboardingSwipeHint() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let taskCell = self.tasksTableView.cellForRow(at: indexPath) as? TaskCell else {return}
        
        if UserDefaultLogic().firstTimeAddingTask {
            UserDefaultLogic().firstTimeAddingTask.toggle()
            taskCell.animateSwipeHint()
        }
        
    }
    
    private func setupEndTaskBlockItems() {
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        
        self.endTaskBlockButton.isEnabled = false
        self.endTaskBlockButton.setBackgroundImage(UIImage(named: "end-task-button-enabled"), for: .normal)
        self.endTaskBlockButton.setBackgroundImage(UIImage(named: "end-task-button-disabled"), for: .disabled)
        
        if deviceName == "iphone8" {
            self.endTaskBlockLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            self.endTaskBlockButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        }
    }
    
    /// This functions in to setup the navBar items
    /// - Author: Antônio Carlos
    private func setupNavBarItems() {
        
        //Gets the navBar to ranking and profile buttons
        guard let navBar = navigationController?.navigationBar else {return}
        
        navigationItem.title = NSLocalizedString("myTasks", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setRankingButtonItem(navBar: navBar)
        self.setProfileButtonItem(navBar: navBar)
    }
    
    private func setAddTasksButton() {
        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        if UserDefaultLogic().isEnglish{
            self.addTasksButton.setBackgroundImage(UIImage(named: "addTasks"), for: .normal)
            self.addTasksButton.setBackgroundImage(UIImage(named: "addTasks")?.translucentImage(withAlpha: 0.5), for: .disabled)
        } else{
        self.addTasksButton.setBackgroundImage(UIImage(named: "botao-adicionar-tarefas-\(deviceName)"), for: .normal)
        self.addTasksButton.setBackgroundImage(UIImage(named: "botao-adicionar-tarefas-\(deviceName)")?.translucentImage(withAlpha: 0.5), for: .disabled)
        }
    }
    
    
    /// This function is to change the view to see the profile when user taps on profile button
    /// - Author: Antônio Carlos
    @objc func didTapOnProfileButton() {
        let profileST = UIStoryboard(name: "Profile", bundle: nil)
        
        let profileVC = profileST.instantiateInitialViewController()
        
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }
    
    /// This function is to change the view to see ranking when user taps on ranking button
    /// Description: Presenting an SwiftUI View using HostingController. declaring two completion for
    ///  his navigation operations, dismiss and present.
    /// - Author: Guilherme Dalosto
    @objc func didTapOnRankingButton() {
        
        self.orderNearbyButton.isUserInteractionEnabled = false
        self.orderAllButton.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.orderNearbyButton.isUserInteractionEnabled = true
            self.orderAllButton.isUserInteractionEnabled = true
        }
        
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        
        setupButtonsOnRankingScreen()
        
        // TESTES        
        if UserDefaultLogic().userId == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateInitialViewController()!
            self.navigationController?.pushViewController(loginVC, animated: true)
        
        } else if !UserDefaultLogic().didSetUsername {
            let storyboard = UIStoryboard(name: "Username", bundle: nil)
            let usernameVC = storyboard.instantiateInitialViewController()!
            self.navigationController?.pushViewController(usernameVC, animated: true)
        } else {
            let hostingController = UIHostingController(rootView: RankingView())
            hostingController.title = "Ranking"
            self.rankingController = hostingController.rootView
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        
    }
    
    @objc func didTapOnAllRankingButton(){
        if !canClick{
            self.rankingController!.UsersList.users = self.rankingController!.UsersList.usersTop
            self.orderAllButton.setBackgroundImage(UIImage(named: "selectedAll"), for: .normal)
            self.orderNearbyButton.setBackgroundImage(UIImage(named: "nonSelectedNear"), for: .normal)
            self.canClick.toggle()
        }
    }
    
    
    @objc func didTapOnNearbyRankingButton(){
        if self.canClick{
            self.rankingController!.UsersList.users = self.rankingController!.manager!.showRankingByProximityUsers(userId: self.rankingController!.coreWorker!.fetchUserID(), users: self.rankingController!.UsersList.users)
            self.orderAllButton.setBackgroundImage(UIImage(named: "nonSelectedAll"), for: .normal)
            self.orderNearbyButton.setBackgroundImage(UIImage(named: "selectedNear"), for: .normal)
            self.canClick.toggle()
        }
        
    }
    
    func setupButtonsOnRankingScreen(){
        guard let navBar = navigationController?.navigationBar else {return}
        
        setAllRankingButtonItem(navBar: navBar)
        setNearbyRankingButtonItem(navBar: navBar)
    }
    
    
    private func setAlertWhenCompleteTask() {
        let backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "complete-task-alert"))
        backgroundImageView.center = self.view.center
        
        
        guard let window = self.view.window else {return}
        window.addSubview(backgroundImageView)
        window.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .allowAnimatedContent, animations: {
            backgroundImageView.alpha = 0.0
        }) { (_) in
            backgroundImageView.removeFromSuperview()
            window.isUserInteractionEnabled = true
        }
    }
    
    
    
    
    internal func actionTask(indexPath: IndexPath, action: TaskActionsEnum) {
        guard let taskCell = tasksTableView.cellForRow(at: indexPath) as? TaskCell else {return}
        
        switch action {
        case .complete:
            self.setAlertWhenCompleteTask()
            self.taskBlock.actionTask(idTask: taskCell.task.id_task, action: action)
            
            if !(UserDefaultLogic().askForReview) {
                if #available( iOS 10.3,*){
                    SKStoreReviewController.requestReview()
                    UserDefaultLogic().askForReview = true
                }
            }
            
        case .delete:
            self.presentDeleteTaskAlert(idTask: taskCell.task.id_task)
        default:
            self.taskBlock.actionTask(idTask: taskCell.task.id_task, action: action)
        }
        
        self.tasksUncompleted = self.taskBlock.getAmountOfUncompletedTasks()
        
        self.tasksTableView.reloadData()
    }
    
    internal func presentDeleteTaskAlert(idTask: UUID) {
        let alertController = UIAlertController(title: NSLocalizedString("warning", comment: ""), message: NSLocalizedString("messageWarning", comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (_) in
            self.taskBlock.actionTask(idTask: idTask, action: .delete)
            self.tasksUncompleted = self.taskBlock.getAmountOfUncompletedTasks()
            self.tasksTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    internal func presentSimpleAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentWith(task: Task?) {
        let storyboard = UIStoryboard(name: "AddTasks", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? AddTasksViewController else { return }
        
        vc.task = task
        vc.tasksViewControllerDelegate = self
        
        vc.callBackClosure = { [weak self] in
            if self?.taskBlockBuilder?.tasks.count == 6 && self!.editionMode {
                self?.endTaskBlockButton.isEnabled = true
                self?.endTaskBlockLabel.text = NSLocalizedString("organize", comment: "")
                self?.runAnimationOfEndTaskBlockLabel()
                self?.tasksTableView.isEditing = true
                self?.tasksTableView.allowsSelectionDuringEditing = true
                self?.tasksTableView.dragInteractionEnabled = true
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func runAnimationOfEndTaskBlockLabel() {
        self.endTaskBlockLabel.alpha = 0.0
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveLinear], animations: {
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                self.endTaskBlockLabel.alpha = 1.0
            }
        }, completion: nil)
    }
    
}


extension TasksViewController {
    
    /// This function adds the ranking button to the navBar
    /// - Parameter navBar: The navBar of navigationController
    /// - Author: Antônio Carlos
    private func setRankingButtonItem(navBar: UINavigationBar) {
        //Creates The button
        let rankingButton = UIButton(type: .system)
        rankingButton.setBackgroundImage(UIImage(named: "ranking_item"), for: .normal)
        rankingButton.addTarget(self, action: #selector(didTapOnRankingButton), for: .touchUpInside)
        rankingButton.frame = CGRect(x: 0, y: 0, width: 22, height: 38)
        
        //Adds the button to the navbar
        navBar.addSubview(rankingButton)
        
        //Sets the constraint of button
        let trailingContraint = NSLayoutConstraint(item: rankingButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: navBar, attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: rankingButton, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: -6)
        rankingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
    }
    
    
    private func setNearbyRankingButtonItem(navBar: UINavigationBar) {
        //Creates The button
        
        orderNearbyButton.setBackgroundImage(UIImage(named: "nonSelectedNear"), for: .normal)
        orderNearbyButton.addTarget(self, action: #selector(didTapOnNearbyRankingButton), for: .touchUpInside)
        orderNearbyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        //Adds the button to the navbar
        navBar.addSubview(orderNearbyButton)
        
        //Sets the constraint of button
        let trailingContraint = NSLayoutConstraint(item: orderNearbyButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: navBar, attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: orderNearbyButton, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: -6)
        orderNearbyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
    }
    
    private func setAllRankingButtonItem(navBar: UINavigationBar) {
        //Creates The button
        orderAllButton.setBackgroundImage(UIImage(named: "selectedAll"), for: .normal)
        orderAllButton.addTarget(self, action: #selector(didTapOnAllRankingButton), for: .touchUpInside)
        orderAllButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        //Adds the button to the navbar
        navBar.addSubview(orderAllButton)
        
        //Sets the constraint of button
        let trailingConstraint = NSLayoutConstraint(item: orderAllButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: navBar, attribute: .trailingMargin, multiplier: 1.0, constant: -64)
        let bottomConstraint = NSLayoutConstraint(item: orderAllButton, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: -6)
        orderAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingConstraint, bottomConstraint])
    }
        
        /// This function adds the profile button to the navBar
        /// - Parameter navBar: The navBar of navigationController
        /// - Author: Antônio Carlos
        private func setProfileButtonItem(navBar: UINavigationBar) {
            //Creates The button
            let profileButton = UIButton(type: .system)
            profileButton.setBackgroundImage(UIImage(named: "profile_item"), for: .normal)
            profileButton.addTarget(self, action: #selector(didTapOnProfileButton), for: .touchUpInside)
            profileButton.frame = CGRect(x: 0, y: 0, width: 22, height: 38)
            
            //Adds the button to the navbar
            navBar.addSubview(profileButton)
            
            //Sets the constraint of button
            profileButton.widthAnchor.constraint(equalToConstant: profileButton.frame.width).isActive = true
            profileButton.heightAnchor.constraint(equalToConstant: profileButton.frame.height).isActive = true
            let trailingConstraint = NSLayoutConstraint(item: profileButton, attribute:
                .trailingMargin, relatedBy: .equal, toItem: navBar, attribute: .trailingMargin, multiplier: 1.0, constant: -64)
            let bottomConstraint = NSLayoutConstraint(item: profileButton, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: -6)
            profileButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([trailingConstraint, bottomConstraint])
        }
        
        
        private func setTasksTableView(deviceName: String) {
            
            if taskBlock.includedTasks.isEmpty && !editionMode {
                
                self.noTasksLabel.isHidden = false
                self.noTasksLabel.isHidden = false
                self.tasksTableView.isHidden = true
                
                switch deviceName {
                case "iphone8":
                    setLayoutNoTasksLabel(fontSize: 18, widthMultiplier: 0.67)
                    setLayoutNoTasksBackground(deviceName: deviceName, widthMultiplier: 0.768, heightMultiplier: 0.5727)
                    break
                case "iphoneX":
                    setLayoutNoTasksLabel(fontSize: 22, widthMultiplier: 0.76)
                    setLayoutNoTasksBackground(deviceName: deviceName, widthMultiplier: 0.86, heightMultiplier: 0.5323)
                    break
                case "ipad":
                    //Not implemented yet
                    break
                default:
                    print("")
                }
                
            } else {
                self.noTasksLabel.isHidden = true
                self.noTasksLabel.isHidden = true
                self.noTasksLabel.removeFromSuperview()
                self.noTasksBackground.removeFromSuperview()
                self.tasksTableView.isHidden = false
                
                switch deviceName {
                case "iphone8":
                    self.setAutoLayoutTasksTableView(widthMultiplier: 0.81, heightMultiplier: 0.685, topConstant: self.view.frame.height*0.2)
                case "iphoneX":
                    self.setAutoLayoutTasksTableView(widthMultiplier: 0.87, heightMultiplier: 0.605, topConstant: self.view.frame.height*0.21)
                case "ipad":
                    //Not implemented yet
                    break
                default:
                    print("")
                }
            }
            
            
        }
        
        private func setAutoLayoutTasksTableView(widthMultiplier: CGFloat, heightMultiplier: CGFloat, topConstant: CGFloat) {
            self.tasksTableView.translatesAutoresizingMaskIntoConstraints = false
            self.tasksTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.tasksTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: heightMultiplier, constant: 0).isActive = true
            self.tasksTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: widthMultiplier, constant: 0).isActive = true
            self.tasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant).isActive = true
            
            self.cellSpacingHeight = (self.view.frame.height*heightMultiplier)*0.045
        }
        
        private func setLayoutNoTasksLabel(fontSize: CGFloat, widthMultiplier: CGFloat) {
            self.noTasksLabel.text = NSLocalizedString("noActivity", comment: "")
            self.noTasksLabel.numberOfLines = 2
            self.noTasksLabel.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: fontSize)
            self.noTasksLabel.textColor = UIColor(rgb: 0x979797)
            self.noTasksLabel.textAlignment = .center
            
            self.noTasksLabel.sizeToFit()
            self.view.addSubview(self.noTasksLabel)
            
            self.noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
            self.noTasksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.noTasksLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.20).isActive = true
            self.noTasksLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: widthMultiplier).isActive = true
        }
        
        private func setLayoutNoTasksBackground(deviceName: String, widthMultiplier: CGFloat, heightMultiplier: CGFloat) {
            self.noTasksBackground = UIImageView(image: UIImage(named: "no-tasks-\(deviceName)"))
            self.noTasksBackground.contentMode = .scaleAspectFit
            
            self.view.addSubview(self.noTasksBackground)
            
            self.noTasksBackground.translatesAutoresizingMaskIntoConstraints = false
            self.noTasksBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.noTasksBackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.28).isActive = true
            self.noTasksBackground.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: widthMultiplier).isActive = true
            self.noTasksBackground.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: heightMultiplier).isActive = true
        }
        
        
        
}

extension TasksViewController: TasksViewControllerDelegate {
    
    func addTask(task: Task) {
        guard let taskBlockBuilder = self.taskBlockBuilder else {return}
        
        taskBlockBuilder.addTask(task: task)
        self.tasksTableView.reloadData()
    }
    
    func moveRows() {
        UIView.animate(withDuration: 1.0, animations: {
            self.tasksTableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0))
        }, completion: nil)
    }
    
}
