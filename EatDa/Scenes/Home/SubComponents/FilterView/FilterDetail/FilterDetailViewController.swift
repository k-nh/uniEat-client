//
//  FilterDetailViewController.swift
//  EatDa
//
//  Created by 김나희 on 2022/04/02.
//

import UIKit

final class FilterDetailViewController: UIViewController {

    // MARK: - UIComponent
    private lazy var  searchBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(imageLiteralResourceName: "search")
        return button
    }()
        
    private lazy var  noticeBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(imageLiteralResourceName: "bell")
        return button
    }()
    
    let headerView = FilterHeaderView(
        frame: CGRect(
            origin: .zero,
            // 해당 디바이스 너비만큼
            size: CGSize(width: UIScreen.main.bounds.width, height: 60.0)
        )
    )
    
    private lazy var filterTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .systemBackground
        tableview.rowHeight = 87.34
        tableview.separatorColor = .lightGray
        tableview.tableHeaderView = headerView

        // api 연결할때 rx로 코드 변경할 예정
        tableview.delegate = self
        tableview.dataSource = self

        tableview.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")

        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func bind(_ viewModel: RecommendDetailViewModel) {
        
    }

}

extension FilterDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as? RestaurantTableViewCell
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.setupLayout()

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97.34
    }

}

private extension FilterDetailViewController {
    func setLayout() {
        setNavigation()
        view.addSubview(filterTableView)
        filterTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setNavigation() {
        self.navigationItem.title = "조회하기"
        self.navigationItem.rightBarButtonItems = [noticeBarButton, searchBarButton]
        let backButtonImage = UIImage(named: "back")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0))
        self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.myBoldSystemFont(ofSize: 16)]
    }

}
