//
//  SceneDelegate.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navController = UINavigationController(rootViewController: HomeVC())
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        coordinator = MainCoordinator(navController: navController)
        coordinator?.start()
        window?.makeKeyAndVisible()
    }

}
