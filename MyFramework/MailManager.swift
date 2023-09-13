//
//  MailManager.swift
//  MyFramework
//
//  Created by KYUBO A. SHIM on 2023/09/10.
//

import MessageUI
import UIKit

public final class VersionManager {
    func getLatestVersion() -> String? {
        guard let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        let version = appStoreVersion
        print(version)
        return version
    }
    
    func getCurrentVersion() -> String? {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        print(version)
        return version
    }
    
    func shouldUpdate() -> Bool {
        guard let currentVersion = getCurrentVersion(),
              let latestVersion = getLatestVersion() else { return false }
        print("Current Version: \(currentVersion)", "Latest Version: \(latestVersion)")
        
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let latestVersionArray = latestVersion.split(separator: ".").map { $0 }
        
        let currentMajorVersion = currentVersionArray[0]
        let currentMinorVersion = currentVersionArray[1]
        let currentMaintenanceVersion = currentVersionArray[2]
        
        let latestMajorVersion = latestVersionArray[0]
        let latestMinorVersion = latestVersionArray[1]
        let latestMaintenanceVersion = latestVersionArray[2]
        
        if currentMajorVersion < latestMajorVersion {
            // 취소가 없는 Alert
        }
        
        if currentMinorVersion < latestMinorVersion {
            // 취소가 있지만, Warning 이 있는 Alert
        }
        
        if currentMaintenanceVersion < latestMaintenanceVersion {
            // 취소가 있는 Alert
        }
        
        return false
    }
}

open class MailManager: UIViewController {
    let device = UIDevice.current
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MailManager: MFMailComposeViewControllerDelegate {
    public func sendFeedbackMail(userOf user: String?) {
        if MFMailComposeViewController.canSendMail() {
            let deviceName = device.name
            let versionManager = VersionManager()
            guard let appVersion: String = versionManager.getCurrentVersion(), let userName = user else { return }

            let mailViewController = MFMailComposeViewController()
            let toMail = "tellingmetime@gmail.com"
            let message = """
                          
                          안녕하세요, 텔링미입니다.
                          어떤 내용을 텔링미에게 전달하고 싶으신가요? 자유롭게 작성해주시면 확인 후 답변 드리겠습니다. 감사합니다.:grinning:
                          📱 쓰고 있는 핸드폰 기종 (예:아이폰 12): \(deviceName)
                          🧭 앱 버전: \(appVersion)
                          
                          ⚠️ 오류를 발견하셨을 경우 ⚠️
                          📍발견한 오류 :
                          
                          📷 오류 화면 (캡쳐 혹은 화면녹화):

                          
                          """
            mailViewController.mailComposeDelegate = self
            mailViewController.setToRecipients([toMail])
            mailViewController.setSubject("")
            mailViewController.setMessageBody(message, isHTML: false)
            self.present(mailViewController, animated: true)
        } else {
            print("Popping the EmailVC up failed.")
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
