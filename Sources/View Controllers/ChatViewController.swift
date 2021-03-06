import UIKit
import MessageKit
import InputBarAccessoryView

/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource {
    private var bSDK: BehavioSecIOSSDK = BehavioSecIOSSDK.shared()
    var status = ""
    lazy var tMessage: UITextField = {
        let textField = UITextField()
        return textField
    } ()
    let behavioSession: BehavioSession = BehavioSession(user: "marcofanti2@behaviosec.com")

    var chatService: ChatService!
    var chatbotService: ChatbotService!
    var member: Member!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    var messageList: [MockMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
        Network.sessionId = ""
        print ("viewDidLoad " + Network.sessionId)
                  /*
        SampleData.shared.callNetworkAF() {
            (initial: String) in
            self.add3(initial: initial)
            print("got back: \(initial)")
        }
        print("**************************"  + initial) */
//        add1(initial: initial)
        title = "BehavioSec "
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MockSocket.shared.connect(with: [SampleData.shared.marco])
            .onNewMessage { [weak self] message in
                self?.insertMessage(message)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MockSocket.shared.disconnect()
        audioController.stopAnyOngoingPlaying()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        behavioSession.finalize()
        print("10 bsdk finalize ")
        bSDK.clearRegistrations()
        print("11 bsdk clearRegistrations ")
        Network.sessionId = ""
        print ("viewWillDisappear " + Network.sessionId)
    }

       func setUpChatbot() {
           member = Member(name: .randomName, color: .random)
           
           chatService = ChatService(member: member, onRecievedMessage: {
               [weak self] message in
            print("Message received from user " + message.text)
//               self?.messages.append(message)
//               self?.messagesCollectionView.reloadData()
//               self?.messagesCollectionView.scrollToBottom(animated: true)
           })
                      
           chatService.connect()
       }
       
       func setup() {
           print("1 - bsdk registerKbdTarget ")
           bSDK.registerKbdTarget(withID: tMessage, andName: "CREDIT_INPUT", andTargetType: NORMAL_TARGET)
           print("2 - bsdk addInformation ")
           bSDK.addInformation("data from input view", withName: "message_data")
           print("3 - bsdk addInformation ")
           bSDK.addInformation("message1", withName: "viewIdentifier")
           
           //TouchSDK
           print("4 - bsdk enableTouch ")
           bSDK.enableTouch(with: self);
           print("5 - bsdk startMotionDetect ")
           bSDK.startMotionDetect()
       }

    func loadFirstMessages() {
        /*
        DispatchQueue.global(qos: .userInitiated).async {
            let count = 1 // UserDefaults.standard.mockMessagesCount()
            SampleData.shared.getMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        } */
    }
    
    func add1(initial: String) {
        DispatchQueue.global(qos: .userInitiated).async {
        SampleData.shared.getMessages1(initial: initial) { messages in
            DispatchQueue.main.async {
                self.messageList = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            }
        }
        }
    }
    
    func add2(initial: String) {
         DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            print("calling add2 with initial " + initial)
            SampleData.shared.getMessages1(initial: initial) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    

    func add3(initial: String) {
         DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            print("calling add3 with initial " + initial)
            var message = initial
            let splitInitial = initial.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            if (splitInitial.count > 1) {
                let str = String(splitInitial[0])
                let range = str.index(after: str.startIndex)..<str.endIndex
                self.status = String(str[range])
                message = String(splitInitial[1])
            }
            SampleData.shared.getMessages1(initial: message) { messages in
                DispatchQueue.main.async {
                    let mlSize = self.messageList.count
                    print("size = " + String(mlSize))
                    self.messageList.insert(contentsOf: messages, at: mlSize)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.messagesCollectionView.scrollToBottom()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc
    func loadMoreMessages() {
        /*
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        } */
    }
    
    func thisIsWhatShouldBeCalledOnResponseFromNetwork(message: String) {
        print("***************************** I got it \(message)")
        add3(initial: message)
    }
    
    @objc
    func printChat() {
        let timingData: String? = bSDK.getSummary()
        print("6 - bsdk getSummary ")

        print("7 - bsdk getScoreForTimings ")

        print("8 - bsdk clearTimingData ")
        bSDK.clearTimingData()
        print("9 - bsdk startMotionDetect ")
        bSDK.startMotionDetect()
        let network = Network()
        network.callNetwork(timingData: timingData!, text: tMessage.text ?? "", completion: thisIsWhatShouldBeCalledOnResponseFromNetwork)
        print("send4 " + (tMessage.text ?? " No text"))
        let messageText = tMessage.text
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            let user = SampleData.shared.currentSender
            let message = MockMessage(text: messageText ?? "", user: user, messageId: UUID().uuidString, date: Date())
            self.status = "Sent"
           // insertMessage(message)
            
            
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessage(message)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }

        tMessage.text = nil
        messageInputBar.sendButton.isEnabled = true
        //configureMessageInputBarForChat()

        // #endif
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        
        tMessage.textColor = UIColor.blue
        
        messageInputBar.setMiddleContentView(tMessage, animated: false)
/*
        messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
        
        
        messageInputBar.layer.shadowColor = UIColor.black.cgColor
        messageInputBar.layer.shadowRadius = 4
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        messageInputBar.separatorLine.isHidden = true */
        tMessage.textColor = UIColor.blue

 //       messageInputBar.setMiddleContentView(tMessage, animated: false)
        
        //messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 52, animated: false)
        //let bottomItems = [makeButton(named: "ic_at"), makeButton(named: "ic_hashtag"), .flexibleSpace]
        //messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        
        messageInputBar.sendButton.activityViewColor = .white
        messageInputBar.sendButton.backgroundColor = .primaryColor
        messageInputBar.sendButton.layer.cornerRadius = 10
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .highlighted)
        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .disabled)
        messageInputBar.sendButton.addTarget(self, action: #selector(printChat), for: .touchUpInside)
        tMessage.text = nil
        tMessage.textColor = UIColor.black
        messageInputBar.sendButton.isEnabled = true
        
        print("1 - bsdk registerKbdTarget ")
        bSDK.registerKbdTarget(withID: tMessage, andName: "CREDIT_INPUT", andTargetType: NORMAL_TARGET)
        print("2 - bsdk addInformation ")
        bSDK.addInformation("data from input view", withName: "message_data")
        print("3 - bsdk addInformation ")
        bSDK.addInformation("message1", withName: "viewIdentifier")
        
        //TouchSDK
        print("4 - bsdk enableTouch ")
        bSDK.enableTouch(with: self);
        print("5 - bsdk startMotionDetect ")
        bSDK.startMotionDetect()

    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        print("here 1")
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return SampleData.shared.currentSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let thisStatus = status
        return NSAttributedString(string: thisStatus, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
 //       let range = NSRange(location: 0, length: attributedText.length)
/*        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
*/
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}
