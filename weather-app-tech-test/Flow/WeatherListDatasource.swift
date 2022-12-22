//
//  WeatherDatasource.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 18/12/2022.
//

import UIKit

fileprivate enum Item: Hashable {
    case current(Forecast)
    case forecast(Forecast)
}

fileprivate enum Section: Int, Hashable {
    case current
    case forecast
}

final class WeatherListDatasource {
    // MARK:
    
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // MARK: Interface
    
    func update(withCurrent current: Forecast, forecast: [Forecast]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.current, .forecast])
        snapshot.appendItems([Item.current(current)], toSection: .current)
        snapshot.appendItems(forecast.map { Item.forecast($0) }, toSection: .forecast)
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
    func buildDatasource(forCollectionView collectionView: UICollectionView) {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
                case .current:
                    let cell: CurrentWeatherCell? = collectionView.dequeue(for: indexPath)
                        
                    if case let .current(model) = item {
                        cell?.viewModel = CurrentWeatherViewModel(forecast: model)
                    }
                        
                    return cell
                    
                case .forecast:
                    let cell: ForecastCell? = collectionView.dequeue(for: indexPath)
                        
                    if case let .forecast(model) = item {
                        cell?.viewModel = ForecastViewModel(forecast: model)
                    }
                        
                    return cell
            }
        }
    }

    var collectionViewLayout:  UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                    
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            if sectionKind == .forecast {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(80))
                let section = NSCollectionLayoutSection(group: .horizontal(layoutSize: size,
                                                                           subitem: .init(layoutSize: size),
                                                                           count: 1))
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 20, leading: 20, bottom: 100, trailing: 20)
                return section
            } else {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(200))
                let section = NSCollectionLayoutSection(group: .horizontal(layoutSize: size,
                                                                           subitem: .init(layoutSize: size),
                                                                           count: 1))
                return section
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

