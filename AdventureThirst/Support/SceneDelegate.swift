//
//  SceneDelegate.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 08.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        Task {
            let authUser = try? await AuthenticationManager.shared.getCurrentSession()
            let auth = SignUpOrLogInVC(isModal: false)
            if let authUser {
//                let navCont = UINavigationController(rootViewController: auth)
//                let personalInfo = try await DatabaseManager.shared.fetchToDoItems(for: authUser.uid)
//                let profilePhotoData = try await StorageManager.shared.fetchProfilePhoto(for: authUser)
//                let companies = try await DatabaseManager.shared.fetchCompany(for: authUser.uid)
//                var appCompanies: [AppCompany] = []
//                
//                for company in appCompanies {
//                    do {
//                        let photoData = try await StorageManager.shared.fetchCompanyPhoto(for: company.name)
//                        let appCompany = AppCompany(name: company.name, description: company.description, photo: photoData, address: company.address, activities: company.activities, phoneNumber: company.phoneNumber, openHours: company.openHours, userUid: company.userUid)
//                        appCompanies.append(appCompany)
//                        let userData = UserData(uid: authUser.uid, email: authUser.email ?? "", name: personalInfo[0].name, lastName: personalInfo[0].lastName, middleName: personalInfo[0].middleName, photoData: profilePhotoData)
//                        navCont.pushViewController(ATTabBarController(userData: userData, appCompanies: appCompanies), animated: false)
//                        window?.rootViewController = navCont
//                        return
//                    } catch {
//                        
//                    }
//                }
//                print("shiting shit \(appCompanies)")
                
                let navCont = UINavigationController(rootViewController: auth)

                do {
                    let personalInfo = try await DatabaseManager.shared.fetchToDoItems(for: authUser.uid)
                    let profilePhotoData = try await StorageManager.shared.fetchProfilePhoto(for: authUser)
                    let companies = try await DatabaseManager.shared.fetchCompany(for: authUser.uid)
                    var appCompanies: [AppCompany] = []
                    
                    for company in companies {
                        // Fetch company photo asynchronously
                        let photoData = try await StorageManager.shared.fetchCompanyPhoto(for: company.name)
                        let appCompany = AppCompany(
                            name: company.name,
                            description: company.description,
                            photo: photoData,
                            address: company.address,
                            activities: company.activities,
                            phoneNumber: company.phoneNumber,
                            openHours: company.openHours,
                            userUid: company.userUid
                        )
                        appCompanies.append(appCompany)
                    }
                    
                    // After all companies are processed
                    let userData = UserData(
                        uid: authUser.uid,
                        email: authUser.email ?? "",
                        name: personalInfo[0].name,
                        lastName: personalInfo[0].lastName,
                        middleName: personalInfo[0].middleName,
                        photoData: profilePhotoData
                    )
                    navCont.pushViewController(ATTabBarController(userData: userData, appCompanies: appCompanies), animated: false)
                    window?.rootViewController = navCont
                    
                    // Print appCompanies after it's populated
                    print(appCompanies)
                } catch {
                    print("Error: \(error)")
                }

            } else {
                window?.rootViewController = UINavigationController(rootViewController: auth)
            }
        }
        
        window?.makeKeyAndVisible()
        
        
        
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

