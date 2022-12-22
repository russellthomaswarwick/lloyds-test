//
//  SceneDelegate.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 14/12/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let viewController = WeatherViewController(viewModel: WeatherViewModel())

        window.rootViewController = viewController

        self.window = window
        window.makeKeyAndVisible()
    }
}
