//
//  TodoListVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class TodoListVC: UIViewController {
    internal lazy var tableView: UITableView = UITableView()
    
    internal var vm: TodoListVM = TodoListVM()
    
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
        print("Open form page")
        print(Date.localDate())
    }
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        
        cell.task = vm.tasks[indexPath.row]
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
