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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
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
        let task: TaskModel = vm.tasks[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = task.date.timeFormatted
        cell.detailTextLabel?.text = task.date.timeFormatted
        return cell
    }
}
