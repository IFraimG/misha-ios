import UIKit
import Social

import UniformTypeIdentifiers
//projectid mishaproject-8345c firebase
class ShareViewController: SLComposeServiceViewController {
    private var enteredText: String?
    private var selectedText: String?
    private var selectedURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 400, height: 600)
        self.view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = extensionItem.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                    itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { [weak self] (item, error) in
                        if let text = item as? String {
                            self?.selectedText = text
                            DispatchQueue.main.async {
                                self?.reloadConfigurationItems()
                            }
                        }
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    handleURL(itemProvider)
                }
        }
    }
    
    override func isContentValid() -> Bool {
        return selectedText != nil && !selectedText!.isEmpty || selectedURL != nil
    }
    
    override func configurationItems() -> [Any]! {
        var items = [SLComposeSheetConfigurationItem]()
        
        let textItem = SLComposeSheetConfigurationItem()!
        textItem.title = "Введите описание"
        textItem.value = "Перейти"
        textItem.tapHandler = {
            let textInputVC = TextInputViewController()
            textInputVC.delegate = self
            self.pushConfigurationViewController(textInputVC)
        }
        
        items.append(textItem)
        
        if let selectedText = selectedText {
            let selectedTextItem = SLComposeSheetConfigurationItem()!
            selectedTextItem.title = "Выделенный текст"
            selectedTextItem.value = selectedText
            items.append(selectedTextItem)
        }
        
        return items
    }
    
    override func didSelectPost() {
    
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func handleURL(_ itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
            if let error = error {
                print("Failed to load URL: \(error.localizedDescription)")
                return
            }
            if let url = item as? URL {
                self?.selectedURL = url
                DispatchQueue.main.async {
                    self?.reloadConfigurationItems()
                }
                print("Loaded URL: \(url)")
            }
        }
    }
    
}

extension ShareViewController: TextInputDelegate {
    func didEnterText(_ text: String) {
        enteredText = text
        reloadConfigurationItems()
    }
}
