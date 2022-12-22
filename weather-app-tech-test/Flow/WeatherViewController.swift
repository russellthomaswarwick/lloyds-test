//
//  ViewController.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 14/12/2022.
//

import UIKit
import Combine
import StackKit
import ConstraintKit

final class WeatherViewController: UIViewController {
    
    // MARK: UI
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.refresh()
        }), for: .touchUpInside)
        return button
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.color = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .blue
        control.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.refresh(showLoading: false)
        }), for: .valueChanged)
        return control
    }()
    
    private lazy var errorStack = HStack {
        VStack {
            errorLabel
            Spacer(h: 15)
            VStack {
                retryButton.withFixed(width: 90, height: 30)
            }.alignment(.center)
        }.margin(.horizontal(20))
    }.alignment(.center)
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let datasource = WeatherListDatasource()
    
    // MARK: Dependencies
    
    private let viewModel: WeatherViewModel
    
    // MARK: Init
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setLayout()
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: CollectionView
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = datasource.collectionViewLayout
        collectionView.register(CurrentWeatherCell.self)
        collectionView.register(ForecastCell.self)
        collectionView.refreshControl = refreshControl
        datasource.buildDatasource(forCollectionView: collectionView)
    }
    
    // MARK: Setup View

    private func setAppearance() {
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        errorStack.isHidden = true
    }
    
    private func setLayout() {
        view.VStack(useSafeArea: false) {
            collectionView
        }
        
        errorStack.translatesAutoresizingMaskIntoConstraints = false
        errorStack.backgroundColor = .white
        view.addSubview(errorStack)
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorStack.topAnchor.constraint(equalTo: view.topAnchor),
            errorStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Bind
    
    private func bind() {
        let errorPublisher = viewModel.errorPublisher
        .share()
        .eraseToAnyPublisher()
        
        errorPublisher
        .assign(to: \.text, on: errorLabel)
        .store(in: &cancellables)

        errorPublisher
        .map { $0 == nil }
        .assign(to: \.isHidden, on: errorStack)
        .store(in: &cancellables)

        viewModel.isLoadingPublisher.sink(receiveValue: { [weak self] value in
            if value {
                self?.loadingIndicator.startAnimating()
                self?.collectionView.isHidden = true
                self?.errorStack.isHidden = true
            }
            else {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }).store(in: &cancellables)
        
        viewModel.feedPublisher.sink { [weak self] forecast, weekly in
            self?.collectionView.isHidden = false
            self?.refreshControl.endRefreshing()
            self?.datasource.update(withCurrent: forecast, forecast: weekly)
        }.store(in: &cancellables)
    }
}
