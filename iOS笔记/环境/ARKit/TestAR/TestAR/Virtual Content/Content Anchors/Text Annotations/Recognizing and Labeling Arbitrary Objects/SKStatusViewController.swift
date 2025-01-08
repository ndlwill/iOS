//
//  SKStatusViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/30.
//

import ARKit

class SKStatusViewController: UIViewController {
    
    enum MessageType {
        case trackingStateEscalation
        case planeEstimation
        case contentPlacement
        case focusSquare
        
        static var all: [MessageType] = [
            .trackingStateEscalation,
            .planeEstimation,
            .contentPlacement,
            .focusSquare
        ]
    }
    
    @IBOutlet weak var messagePanel: UIVisualEffectView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var restartExperienceHandler: () -> Void = {}
    
    private let displayDuration: TimeInterval = 6
    
    private var messageHideTimer: Timer?
    
    private var timers: [MessageType: Timer] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
    }
    
    @IBAction func restartDidClicked(_ sender: UIButton) {
        restartExperienceHandler()
    }
    
    func showMessage(_ text: String, autoHide: Bool = true) {
        // Cancel any previous hide timer.
        messageHideTimer?.invalidate()
        
        messageLabel.text = text
        
        // Make sure status is showing.
        setMessageHidden(false, animated: true)
        
        if autoHide {
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration,
                                                    repeats: false,
                                                    block: { [weak self] _ in
                self?.setMessageHidden(true, animated: true)
            })
        }
    }
    
    func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
        showMessage(trackingState.presentationString1, autoHide: autoHide)
    }
    
    func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
        cancelScheduledMessage(for: .trackingStateEscalation)
        
        let timer = Timer.scheduledTimer(withTimeInterval: seconds,
                                         repeats: false,
                                         block: { [unowned self] _ in
            self.cancelScheduledMessage(for: .trackingStateEscalation)
            
            var message = trackingState.presentationString1
            if let recommendation = trackingState.recommendation1 {
                message.append(": \(recommendation)")
            }
            
            self.showMessage(message, autoHide: false)
        })
        
        timers[.trackingStateEscalation] = timer
    }
    
    func cancelScheduledMessage(`for` messageType: MessageType) {
        timers[messageType]?.invalidate()
        timers[messageType] = nil
    }
    
    func cancelAllScheduledMessages() {
        for messageType in MessageType.all {
            cancelScheduledMessage(for: messageType)
        }
    }
    
    private func setMessageHidden(_ hide: Bool, animated: Bool) {
        // The panel starts out hidden, so show it before animating opacity.
        messagePanel.isHidden = false
        
        guard animated else {
            messagePanel.alpha = hide ? 0 : 1
            return
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.beginFromCurrentState],
                       animations: {
            self.messagePanel.alpha = hide ? 0 : 1
        }, completion: nil)
    }
    
}

extension ARCamera.TrackingState {
    var presentationString1: String {
        switch self {
        case .notAvailable:
            return "TRACKING UNAVAILABLE"
        case .normal:
            return "TRACKING NORMAL"
        case .limited(.excessiveMotion):
            return "TRACKING LIMITED\nExcessive motion"
        case .limited(.insufficientFeatures):
            return "TRACKING LIMITED\nLow detail"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.relocalizing):// The AR session is attempting to resume after an interruption.
            return "Recovering from interruption"
        default:
            return "TRACKING UNAVAILABLE"
        }
    }
    
    var recommendation1: String? {
        switch self {
        case .limited(.excessiveMotion):
            return "Try slowing down your movement, or reset the session."
        case .limited(.insufficientFeatures):
            return "Try pointing at a flat surface, or reset the session."
        case .limited(.relocalizing):
            return "Return to the location where you left off or try resetting the session."
        default:
            return nil
        }
    }
}
