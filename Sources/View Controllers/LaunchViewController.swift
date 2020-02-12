/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageKit
import SafariServices

final internal class LaunchViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let cells = ["Banking Demo (BasicExampleViewController)", "Banking Demo (BankingDemoDialogFlowViewController)", "Banking Demo (AdvancedExampleViewController)", "Banking Demo (AutocompleteExampleViewController)", "Password Reset (MessageContainerController)", "Settings", "SSO Demo", "SSO Demo Expensify", "Company", "Solutions"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demos"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = cells[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        switch cell {
        case "Banking Demo (BasicExampleViewController)":
            navigationController?.pushViewController(BasicExampleViewController(), animated: true)
        case "Banking Demo (BankingDemoDialogFlowViewController)":
            navigationController?.pushViewController(BankingDemoDialogFlowViewController(), animated: true)
        case "Banking Demo (AdvancedExampleViewController)":
            navigationController?.pushViewController(AdvancedExampleViewController(), animated: true)
        case "Banking Demo (AutocompleteExampleViewController)":
            navigationController?.pushViewController(AutocompleteExampleViewController(), animated: true)
        case "Password Reset (MessageContainerController)":
            navigationController?.pushViewController(MessageContainerController(), animated: true)
        case "Settings":
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        case "Company":
            guard let url = URL(string: "https://www.behaviosec.com/") else { return }
            openURL(url)
        case "Solutions":
            guard let url = URL(string: "https://www.behaviosec.com/behavioral-biometric-solutions/") else { return }
            openURL(url)
        case "SSO Demo":
            guard let url = URL(string: "https://ping.behaviosec.com:9031/idp/startSSO.ping?PartnerSpId=https%3A%2F%2Fsaml.salesforce.com") else { return }
            openURL(url)
        case "SSO Demo Expensify":
            guard let url = URL(string: "https://ping.behaviosec.com:9031/idp/startSSO.ping?PartnerSpId=https%3A%2F%2Fwww.expensify.com") else { return }
            openURL(url)
        default:
            assertionFailure("You need to implement the action for this cell: \(cell)")
            return
        }
    }
    
    func openURL(_ url: URL) {
        let webViewController = SFSafariViewController(url: url)
        if #available(iOS 10.0, *) {
            webViewController.preferredControlTintColor = .primaryColor
        }
        present(webViewController, animated: true, completion: nil)
    }
}
