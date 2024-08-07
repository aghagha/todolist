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
            let mover: TaskModel = self.vm.tasks.remove(at: actualIndexPath.row)
            let index: Int = self.vm.getFirstCompletedIndex()
            self.vm.tasks.insert(mover, at: index - 1)
            tableView.moveRow(at: actualIndexPath, to: IndexPath(row: index, section: 0))
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
        dragItem.localObject = vm.tasks[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover: TaskModel = vm.tasks.remove(at: sourceIndexPath.row)
        vm.tasks.insert(mover, at: destinationIndexPath.row)
        print(vm.tasks.map( { $0.title }))
    }
}
