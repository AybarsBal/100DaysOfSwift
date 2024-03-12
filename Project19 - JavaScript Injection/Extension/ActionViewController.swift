//
//  ActionViewController.swift
//  Extension
//
//  Created by Yakup Aybars Bal on 29.01.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var scriptsForURL = [String: String]() // Challenge 2
    
    // Challenge 3
    var userScriptsName = [String]()
    var userScripts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // Challenge 3
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScripts))
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(title: "myScripts", style: .plain, target: self, action: #selector(myScripts)))
        
        // Challenge 1
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Templates", style: .plain, target: self, action: #selector(preScript)))
        
        // Challenge 2 & 3
        let defaults = UserDefaults.standard
        if let savedScripts = defaults.object(forKey: "savedScripts") as? Data,let savedNames = defaults.object(forKey: "savedNames") as? Data{
            let decoder = JSONDecoder()
            
            do {
                userScripts = try decoder.decode([String].self, from: savedScripts)
                userScriptsName = try decoder.decode([String].self, from: savedNames)
            } catch {
                print("Loading error")
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // do stuff!
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.loadScriptForUrl() // Challenge 2
                    }
                }
            }
        }
    }
    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        // Challenge 2
        saveScriptForUrl()
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    // Challenge 1
    @objc func preScript() {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show Title", style: .default, handler: { _ in
            self.script.text = "alert(document.title);"
            self.done()
        }))
        ac.addAction(UIAlertAction(title: "Show URL", style: .default, handler: { _ in
            self.script.text = "alert(document.URL);"
            self.done()
        }))
        ac.addAction(UIAlertAction(title: "Show CharaterSet", style: .default, handler: { _ in
            self.script.text = "alert(document.characterSet);"
            self.done()
        }))
        ac.addAction(UIAlertAction(title: "Show Domain", style: .default, handler: { _ in
            self.script.text = "alert(document.domain);"
            self.done()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: - Challenge 2
    
    func saveScriptForUrl() {
        let encoder = JSONEncoder()
        
        if let url = URL(string: pageURL) {
            if let host = url.host {
                scriptsForURL[host] = script.text
                if let urlScripts = try? encoder.encode(scriptsForURL) {
                    let defaults = UserDefaults.standard
                    defaults.set(urlScripts, forKey: "urlScripts")
                }
            }
        }
    }
    
    func loadScriptForUrl() {
        let defaults = UserDefaults.standard
        
        if let urlScripts = defaults.object(forKey: "urlScripts") as? Data {
            let decoder = JSONDecoder()
            
            do {
                scriptsForURL = try decoder.decode([String: String].self, from: urlScripts)
            } catch {
                print("Loading error")
            }
        }
        
        if let url = URL(string: pageURL) {
            if let host = url.host {
                script.text = scriptsForURL[host]
            }
        }
    }
    
    // MARK: - Challenge 3
    @objc func addScripts() {
        let ac = UIAlertController(title: "Add Script", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        ac.textFields?.first?.placeholder = "Name the script"
        
        
        ac.addTextField()
        ac.textFields?[1].placeholder = "Write your script"
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let name = ac.textFields?[0].text, let userScript = ac.textFields?[1].text {
                self.userScripts.append(userScript)
                self.userScriptsName.append(name)
                self.save()
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @objc func myScripts() {
        let ac = UIAlertController(title: "myScripts", message: nil, preferredStyle: .actionSheet)
        
        for i in 0..<userScriptsName.count {
            ac.addAction(UIAlertAction(title: userScriptsName[i], style: .default, handler: { _ in
                self.script.text = self.userScripts[i]
                self.done()
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedScripts = try? encoder.encode(userScripts), let savedNames = try? encoder.encode(userScriptsName) {
            let defaults = UserDefaults.standard
            defaults.set(savedScripts, forKey: "savedScripts")
            defaults.set(savedNames, forKey: "savedNames")
        }
    }
}
