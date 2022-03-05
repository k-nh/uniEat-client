//
//  HomeViewController.swift
//  EatDa
//
//  Created by 김나희 on 2022/01/28.
//

import UIKit
import SnapKit
import RxSwift


class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical  // 세로 스크롤이기 때문
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0

        let titleSectionView = TitleSectionView()
        let filterSectionView = FilterSectionView()
        let recommendSectionView = RecommendSectionView()
        let aroundSectionView = AroundSectionView()
        let mapSectionView = MapSectionView()
    
        // 임의의 뷰 추가하여 스크롤 뷰 아래화면 끝까지 잘보이게
        let spacingView = UIView()
        spacingView.snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
                
        [titleSectionView, filterSectionView, recommendSectionView, aroundSectionView, mapSectionView, spacingView]
            .forEach {
                stackView.addArrangedSubview($0)
            }

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupLayout()
        bind(homeViewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func showDetail(_ sender: AnyObject?){
        let vc = RestaurantDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func bind(_ viewModel: HomeViewModel) {
        searchBarButton.rx.tap
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.pushSearchViewController
            .drive(onNext: { viewModel in
                let viewController = SearchViewController()
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
            .disposed(by: disposeBag)
    }
}

private extension HomeViewController {
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.rightBarButtonItems = [noticeBarButton, searchBarButton]
    }

    func setupLayout(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            // 세로 스크롤만 가능하게 - 가로만 고정
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
