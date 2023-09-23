//
//  MediaPlayerView.swift
//  Pratice12345
//
//  Created by MacBook AIR on 21/09/2023.
//

import Foundation
import UIKit
import AVKit
import MediaPlayer

class MediaPlayerView: UIView {

    
    
    var panGesture:UIPanGestureRecognizer!
    
    var dimssGesture:UIPanGestureRecognizer!
    
    var playlists:[Episode] = []
    var episode:Episode! {
        didSet {
            miniStackView.layer.opacity = 0
            maxStackView.layer.opacity = 1
            setUpNowPlayingInfo()
            setupAudiosession()
            playEpisodeUrl()
            descriptionLabel.text = episode.title
            authorLabel.text = episode.author
           
            guard let url = URL(string: episode.imageUrl  ?? "") else {return}
            mediaPlayerImageView.sd_setImage(with: url)
            miniImageLabel.sd_setImage(with: url) { images, _, _, _ in
                
                guard let image = images else {return}
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let artWork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artWork
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            miniDescriptionLabel.text = episode.title
           
        }
        
    }
    
    let Mediaplayer:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
        
    }()
    
    @IBOutlet weak var mediaPlayerImageView: UIImageView!{
        didSet {
            shrinkImageView()
        }
        
    }
    
    
    
    @IBOutlet weak var mediaPlayerSlider: UISlider!
    
    
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    

    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var miniImageLabel: UIImageView!
    
    @IBOutlet weak var miniDescriptionLabel: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    
    
    @IBOutlet weak var MiniplayAndPauseLable: UIButton!
    
    
    @IBOutlet weak var startLabel: UILabel!
    
    
    @IBOutlet weak var currentSlider: UISlider!
    
    @IBOutlet weak var playAndPause: UIButton!{
      
        didSet {
            playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playAndPause.addTarget(self, action: #selector( handlePlayPause), for: .touchUpInside)
            
        }
        
    }
    
    
    
    @IBOutlet weak var miniStackView: UIStackView!
    
    
    @IBOutlet weak var maxStackView: UIStackView!
    
    @IBAction func miniPlayerFoward(_ sender: Any) {
        let fifteenSeconds = CMTimeMakeWithSeconds(15, preferredTimescale: 1)
        let seekTime = CMTimeAdd(Mediaplayer.currentTime(), fifteenSeconds)
        Mediaplayer.seek(to: seekTime)
        
        
    }
    
    
    
    @IBAction func miniPlayandPauseDidTapped(_ sender: Any) {
        if Mediaplayer.timeControlStatus == .paused {
            playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            Mediaplayer.play()
            enlargeImageView()
        }else {
            playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Mediaplayer.pause()
            shrinkImageView()
        }
    }
    
    fileprivate func setupAudiosession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func handleControlFlow(_ sender: Any) {
        
        let perecentage = currentSlider.value
        
        guard let duration =  Mediaplayer.currentItem?.duration else {return}
        let durationInseconds = CMTimeGetSeconds( duration)
        let seekTimeInSeconds  = Float64(perecentage) * durationInseconds
      
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds,preferredTimescale: 1)
      
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        
        Mediaplayer.seek(to: seekTime)
        
    }
    
    
    
    @IBAction func handleRewind(_ sender: Any) {
        
        let fifteenSeconds = CMTimeMakeWithSeconds(-15, preferredTimescale: 1)
        let seekTime = CMTimeAdd(Mediaplayer.currentTime(), fifteenSeconds)
        Mediaplayer.seek(to: seekTime)
    }
    
    
    
    @IBAction func HandleFoward(_ sender: Any) {
        let fifteenSeconds = CMTimeMakeWithSeconds(15, preferredTimescale: 1)
        let seekTime = CMTimeAdd(Mediaplayer.currentTime(), fifteenSeconds)
        Mediaplayer.seek(to: seekTime)
    }
    
    
   
    
    
    @IBAction func HandleVolume(_ sender:UISlider) {
        
        Mediaplayer.volume = sender.value
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        Mediaplayer.addPeriodicTimeObserver(forInterval:interval , queue: .main){[weak self]  time in
            let totalseconds = time.toDisplayString()
            
            self?.startLabel.text = totalseconds
            
            let endTiime = self?.Mediaplayer.currentItem?.duration.toDisplayString()
            
            self?.endLabel.text = endTiime
            self?.updateCurrentTImerValue()
            self?.setupLockScreenCurrenTime()
        }
        
    }
    
    fileprivate func setupLockScreenCurrenTime() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = Mediaplayer.currentItem else {return}
        let durationSeconds = CMTimeGetSeconds(currentItem.duration)
        
        let elapsedTime  = CMTimeGetSeconds(Mediaplayer.currentTime())
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime]  = elapsedTime
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        
    }
    
    func updateCurrentTImerValue () {
        let currentSeconds = CMTimeGetSeconds(Mediaplayer.currentTime())
        let durationSeconds = CMTimeGetSeconds(Mediaplayer.currentItem?.duration ??  CMTimeMake(value: 1, timescale: 2))
        let percentage =  currentSeconds/durationSeconds
        currentSlider.value =  Float(percentage)
        
        
    }
    
    
    fileprivate func setUpNowPlayingInfo() {
        var nowPlayingInfo = [String:Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
 
    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let shared =   MPRemoteCommandCenter.shared()
        shared.playCommand.isEnabled = true
        shared.playCommand.addTarget {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.Mediaplayer.play()
            self?.playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self?.MiniplayAndPauseLable.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self?.elapsedTimeCheck()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
            return.success
        }
        shared.pauseCommand.isEnabled = true
        
        shared.pauseCommand.addTarget {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.Mediaplayer.pause()
            
            self?.playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self?.MiniplayAndPauseLable.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self?.elapsedTimeCheck()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
            return.success
        }
        
        shared.togglePlayPauseCommand.isEnabled = true
        shared.togglePlayPauseCommand.addTarget {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.handlePlayPause()
            return.success
        }
        
        shared.nextTrackCommand.isEnabled = true
        shared.nextTrackCommand.addTarget{[weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.handleNextTrackApp()
            return.success
        }
        shared.previousTrackCommand.isEnabled = true
        shared.previousTrackCommand.addTarget {[weak self] (_) -> MPRemoteCommandHandlerStatus in
        self?.handlePreviousTrackApp()
        return.success
    }
    }
    
    
    @objc fileprivate func handlePreviousTrackApp() {
        playlists.forEach({print($0.title)})
        
        if playlists.count == 0 {
            return
        }
        
    let currentEpisodesIndex =   playlists.firstIndex { ep in
             return self.episode.title == ep.title && self.episode.author == ep.author
        }
        guard let index = currentEpisodesIndex else {return}
        if index > 0 {
            let nextEpisode = playlists[index - 1]
            self.episode = nextEpisode
            
        }else if index ==  0 {
            self.episode = playlists[0]
        }
    }
    @objc fileprivate func handleNextTrackApp() {
        playlists.forEach({print($0.title)})
        
        if playlists.count == 0 {
            return
        }
        
    let currentEpisodesIndex =   playlists.firstIndex { ep in
             return self.episode.title == ep.title && self.episode.author == ep.author
        }
        guard let index = currentEpisodesIndex else {return}
        if index < playlists.count - 1 {
            let nextEpisode = playlists[index+1]
            self.episode = nextEpisode
            
        }else if index == playlists.count - 1{
            self.episode = playlists[0]
        }
    }
    
    
    func   elapsedTimeCheck() {
        let elapsedTime = CMTimeGetSeconds(Mediaplayer.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }
    
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        setupRemoteControl()
        
        setupInteractionObserver()
     
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingToMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniStackView.addGestureRecognizer( panGesture)
        
        dimssGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDimissPan))
        
        maxStackView.addGestureRecognizer(dimssGesture)
        
        observeTime()
        
        
        
        
    }
    
    func setupInteractionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInteruptions), name: AVAudioSession.interruptionNotification, object: nil)
    }

    @objc func handleInteruptions(notifcation:Notification) {
        guard let userInfo =  notifcation.userInfo else {return}
        guard let type =   userInfo[AVAudioSessionInterruptionTypeKey]  as? UInt else {return}
        if type == AVAudioSession.InterruptionType.began.rawValue {
            playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "pause.fill"), for: .normal)
      
        }else{
           guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return}
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
                MiniplayAndPauseLable.setImage(UIImage(systemName: "play.fill"), for: .normal)
                Mediaplayer.play()
            }
        }
    }
    
    
    fileprivate func observeTime() {
        observePlayerCurrentTime()
        let time  = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        Mediaplayer.addBoundaryTimeObserver(forTimes: times, queue: .main) {[weak self] in
            self?.enlargeImageView()
            self?.lockScreenDuration()
        }
    }
    
    fileprivate func lockScreenDuration(){
        guard let duration = Mediaplayer.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
            
                
    }
    
    @objc func  handlePan(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("Began")
        }else if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            transform = CGAffineTransform(translationX: 0, y:translation.y)
            miniStackView.alpha =  1 + translation.y/200
            maxStackView.alpha = -translation.y/200
            miniStackView.alpha = 0
        }else if gesture.state == .ended {
            handledPanEnded(gesture: gesture)
        }
        
    }
    
    
    
    @objc func  handleDimissPan(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("Began")
        }else if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            maxStackView.transform = CGAffineTransform(translationX: 0, y:translation.y)
        
        }else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseInOut, animations:  {[weak self] in
                self?.maxStackView.transform = .identity
                if translation.y > 50 {
                    if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
                        if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                            mainTabbarController.minimizedPlayerDetails()
                        } else {
                            print("Could not cast rootViewController to MainTabBarViewController")
                        }
                    } else {
                        print("No key window found")
                    }
                }
            })
        }
        
    }
    
    
   
    
    @objc func handlePlayPause() {
        if Mediaplayer.timeControlStatus == .paused {
            playAndPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            Mediaplayer.play()
            enlargeImageView()
        }else {
            playAndPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            MiniplayAndPauseLable.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Mediaplayer.pause()
            shrinkImageView()
        }
    }
    
    
    @IBAction func dimissTapped(_ sender: Any) {
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                maxStackView.layer.opacity = 0
                miniStackView.layer.opacity = 1
                mainTabbarController.minimizedPlayerDetails()
            
                
            } else {
                print("Could not cast rootViewController to MainTabBarViewController")
            }
        } else {
            print("No key window found")
        }
    }
    
    
    fileprivate func playEpisodeUrl() {
        print(episode.streamUrl)
        guard let url = URL(string:episode.streamUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        Mediaplayer.replaceCurrentItem(with: playerItem)
        Mediaplayer.play()
    }
    
 
    
    
    func enlargeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0,usingSpringWithDamping: 0.5, initialSpringVelocity: 1,options: .curveEaseInOut) {
            self.mediaPlayerImageView.transform = .identity
        }
        
    }
    
    func shrinkImageView()
    {
        mediaPlayerImageView.layer.cornerRadius = 5
        mediaPlayerImageView.clipsToBounds = true
        let scale:CGFloat = 0.7
        
        mediaPlayerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)

        
        
    }
    
    
    static func initFromNib() -> MediaPlayerView {
    
        return Bundle.main.loadNibNamed("MediaPlayerView", owner: self)?.first as! MediaPlayerView
        
    }
    
    
    
    func handledPanEnded(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        let velocity = gesture.velocity(in: self.superview)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseInOut, animations:  {[weak self] in
            self?.transform = .identity
            
            if translation.y < -200 || velocity.y < -500{
                if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
                    if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                        
                        mainTabbarController.maximizedPlayerDetails(episode: nil)
                      
                    } else {
                        print("Could not cast rootViewController to MainTabBarViewController")
                    }
                } else {
                    print("No key window found")
                }
            }else {
                
                self?.miniStackView.alpha = 1
                self?.maxStackView.alpha = 0
            }
            
        })
    }
    @objc func  tappingToMaximize() {
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                maxStackView.layer.opacity = 1
                miniStackView.layer.opacity = 0
                mainTabbarController.maximizedPlayerDetails(episode: nil)
              
            } else {
                print("Could not cast rootViewController to MainTabBarViewController")
            }
        } else {
            print("No key window found")
        }
    }
    
    
    
    
}
