//
//  FiltersVC.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 18.12.2024.
//

protocol FilterDelegate: AnyObject {
    func filterWasSelected(selectedFilterOption: FilterOption?)
}

struct FilterOptionData {
    let title: String
    let descroption: String
    let isChoosen = UIImage(systemName: "checkmark")
}

import UIKit

class FiltersVC: UIViewController {
    
    let filterLabel = UILabel()
    let clearButton = UIButton()
    
    let filterOptions: [FilterOptionData] = [
        FilterOptionData(title: "По цене", descroption: "Сначала подешевле"),
        FilterOptionData(title: "По рейтигу", descroption: "Сначала самый высокий"),
        FilterOptionData(title: "По продолжительности", descroption: "Сначала самые продолжительные")
    ]
    var selectedFilterOption: FilterOption?
    weak var delegate: FilterDelegate?
    
    private let filterTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        return table
    }()
    
    init(selectedFilterOption: FilterOption?) {
        self.selectedFilterOption = selectedFilterOption
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        filterLabel.backgroundColor = .white
        
        view.addSubview(filterTable)
        view.addSubview(filterLabel)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.text = "Расположить"
        filterLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        filterLabel.textAlignment = .center
        filterLabel.numberOfLines = 0

        filterTable.separatorStyle = .none
        filterTable.isScrollEnabled = false
        filterTable.delegate = self
        filterTable.dataSource = self
        filterTable.translatesAutoresizingMaskIntoConstraints = false
        filterTable.tableHeaderView = nil
        filterTable.tableFooterView = nil
        
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Сбросить", for: .normal)
        clearButton.setTitleColor(.blue, for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.heightAnchor.constraint(equalToConstant: 80),
            
            clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            clearButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            filterTable.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: -30),
            filterTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func clearButtonPressed() {
        selectedFilterOption = nil
        filterTable.reloadData()
        dismiss(animated: true)
        delegate?.filterWasSelected(selectedFilterOption: nil)
    }
}

extension FiltersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filterTable.dequeueReusableCell(withIdentifier: FilterCell.reuseID, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.set(label: filterOptions[indexPath.row].title, description: filterOptions[indexPath.row].descroption)
        if filterOptions[indexPath.row].title == selectedFilterOption?.rawValue {
            cell.setSelected()
        } else {
            cell.setDefault()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedFilterOption?.rawValue == filterOptions[indexPath.row].title {
            return
        }
        
        for cell in filterTable.visibleCells {
            guard let cell = cell as? FilterCell else { return }
            cell.setDefault()
        }
        guard let selectedCell = filterTable.cellForRow(at: indexPath) as? FilterCell else { return }
        selectedCell.setSelected()
        dismiss(animated: true)
        delegate?.filterWasSelected(selectedFilterOption: FilterOption(rawValue: filterOptions[indexPath.row].title))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white
        return footerView
    }
}
