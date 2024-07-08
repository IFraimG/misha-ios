import UIKit
import Social

import UniformTypeIdentifiers
//projectid mishaproject-8345c firebase
class ShareViewController: SLComposeServiceViewController {
    // description
    private var enteredText: String?
    
    // title
    private var selectedText: String?
    
    private var selectedURL: URL?
    
    private var selectedImage: UIImage?

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
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    handleImage(itemProvider)
                }
        }
    }
    
    override func isContentValid() -> Bool {
        return selectedText != nil && !selectedText!.isEmpty || selectedURL != nil || selectedImage != nil
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
        guard let userDefaults = UserDefaults(suiteName: "group.com.pushok.misha") else { return }
        
        if let enteredText = enteredText {
            userDefaults.set(enteredText, forKey: "description")
        }
        if let selectedText = selectedText {
            userDefaults.set(selectedText, forKey: "title")
        }
        if let selectedURL = selectedURL {
            userDefaults.set(selectedURL.absoluteString, forKey: "url")
        }
        if let selectedImage = selectedImage {
            if let imageData = selectedImage.pngData() {
                userDefaults.set(imageData, forKey: "image")
            } else if let imageData = selectedImage.jpegData(compressionQuality: 1) {
                userDefaults.set(imageData, forKey: "image")
            }
        }
    
//        if let url = URL(string: "mishaopen://") {
//            let context = NSExtensionContext()
//            context.open(url)
//        }
        if let url = URL(string: "mishaopen://") {
             var responder = self as UIResponder?
             while responder != nil {
                 if let app = responder as? UIApplication {
                     app.performSelector(onMainThread: Selector(("openURL:")), with: url, waitUntilDone: true)
                 }
                 responder = responder?.next
             }
         }
        
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
    
    private func handleImage(_ itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] (item, error) in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            if let image = item as? UIImage {
                self?.selectedImage = image
                DispatchQueue.main.async {
                    self?.reloadConfigurationItems()
                }
                print("Loaded image")
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
