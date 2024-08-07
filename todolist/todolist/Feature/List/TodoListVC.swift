//
//  TodoListVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class TodoListVC: UIViewController {
    internal lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    internal var vm: TodoListVM = TodoListVM()
    internal var router: Router = Router.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension TodoListVC {
    private func setupView() {
        view.backgroundColor = .white
        setupNavbar()
        setupTableView()
    }
    
    private func setupNavbar() {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.text = "To Do List"
        label.font = .boldSystemFont(ofSize: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        var configuration: UIButton.Configuration = .plain()
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 4
        configuration.title = "+ New Task"
        configuration.baseForegroundColor = .white
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        button.configuration = configuration
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        
        // MARK: drag and drop UX
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func rightButtonAction(_ sender: UIBarButtonItem) {
        router.openCreateTaskForm(from: self) { [weak self] task in
            self?.vm.tasks.append(task)
            DispatchQueue.main.async {
                MySnackbar.show(in: self!.view, message: "Task added!")
                self?.tableView.reloadData()
            }
        }
    }
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    private func dateFor(section: Int) -> Date {
        let dates: [Date] = Array(vm.groupedTasks.keys).sorted(by: { $0 < $1 } )
        return dates[section]
    }
    
    private func task(for indexPath: IndexPath) -> TaskModel? {
        let date: Date = dateFor(section: indexPath.section)
        return vm.groupedTasks[date]?[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        vm.groupedTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date: Date = dateFor(section: section)
        return vm.groupedTasks[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell, let task = task(for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.task = task
        cell.didComplete = { [weak self] in
            guard let self = self, let actualIndexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            let task: TaskModel? = self.task(for: actualIndexPath)
            let index: Int = self.vm.getFirstCompletedIndex(in: self.dateFor(section: actualIndexPath.section))
            let firstIndexOfSameDay: Int = vm.tasks.firstIndex(where: { $0.dateWithoutTime == task?.dateWithoutTime }) ?? 0
            
            vm.tasks.removeAll(where: { $0.id == task?.id })
            
            let destinationIndexPath: IndexPath = IndexPath(row: index - 1, section: actualIndexPath.section)
            vm.tasks.insert(task!, at: firstIndexOfSameDay + index)
            
            tableView.moveRow(at: actualIndexPath, to: destinationIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task: TaskModel? = task(for: indexPath)
        router.openCreateTaskForm(from: self, task: task) { [weak self] task in
            if let index = self?.vm.tasks.firstIndex(where: { $0.id == task.id }) {
                self?.vm.tasks[index] = task
            }
            MySnackbar.show(in: self!.view, message: "Task updated!")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        router.presetDeleteConfirmation(from: self) { [weak self] in
            if let task = self?.task(for: indexPath) {
                self?.vm.tasks.removeAll(where: { $0.id == task.id })
            }
            DispatchQueue.main.async {
                if self?.tableView.numberOfRows(inSection: indexPath.section) == 1 {
                    self?.tableView.deleteSections([indexPath.section], with: .left)
                    return
                }
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                MySnackbar.show(in: self!.view, message: "Task deleted!", color: .systemRed)
            }
        }
    }
    
    // MARK: section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        header.backgroundColor = .systemGray6
        let label: UILabel = UILabel()
        label.text = dateFor(section: section).formattedDateForDisplay
        label.font = .boldSystemFont(ofSize: 16)
        label.set(superView: header)
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -padding),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -padding)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension TodoListVC: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem: UIDragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = task(for: indexPath)
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveCell(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let shouldMove: Bool = self.tableView(tableView, numberOfRowsInSection: indexPath.section) > 1
        if !shouldMove {
            MySnackbar.show(in: view, message: "Can't move item, edit it directly instead", color: .systemRed)
        }
        return shouldMove
    }
    
    private func moveCell(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var draggedItem: TaskModel? = task(for: sourceIndexPath)
        vm.tasks.removeAll(where: { $0.id == draggedItem?.id })
        var dateAtIndexPath: Date = dateFor(section: destinationIndexPath.section)
        if draggedItem?.hasTime ?? false {
            dateAtIndexPath = dateAtIndexPath.setTime(hour: draggedItem?.date.hour ?? 0, minute: draggedItem?.date.minute ?? 0)
        }
        draggedItem?.date = dateAtIndexPath
        
        let firstIndexOfSameDay: Int = vm.tasks.firstIndex(where: { Calendar.current.isDate($0.date, equalTo: dateAtIndexPath, toGranularity: .day) }) ?? 0
        
        vm.tasks.insert(draggedItem!, at: firstIndexOfSameDay + destinationIndexPath.row)
    }
}
