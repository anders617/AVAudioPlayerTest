//
//  ViewController.swift
//  Audio
//
//  Created by Anders Boberg on 1/19/17.
//  Copyright © 2017 Anders Boberg. All rights reserved.
//

import UIKit
import AVFoundation

extension TimeInterval {
    /**
     Returns string in format mm:ss interpreting this TimeInterval(Double) as seconds.
    */
    var timeString: String {
        let currentMinutes = Int(self) / 60
        let currentSeconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", currentMinutes, currentSeconds)
    }
}

class ViewController: UIViewController {

    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var progressBar: UISlider!
    @IBOutlet var playPauseButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    var progressUpdateTimer:Timer = Timer()
    var audioPlayer: AVAudioPlayer!
    var currentPlaybackRate:Float = 1.0 {
        didSet {
            audioPlayer.rate = currentPlaybackRate
        }
    }
    
    let fastForwardRate:Float = 2.0
    let playRate:Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let moonlight = NSDataAsset(name: "Moonlight")!
        audioPlayer = try! AVAudioPlayer(data: moonlight.data)
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
        
        progressBar.minimumValue = 0
        progressBar.maximumValue = Float(audioPlayer.duration)
        
        currentTimeLabel.text = (0.0).timeString
        remainingTimeLabel.text = audioPlayer.duration.timeString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProgressBar() {
        progressBar.value = Float(audioPlayer.currentTime)
        
        currentTimeLabel.text = audioPlayer.currentTime.timeString
        remainingTimeLabel.text = (audioPlayer.duration - audioPlayer.currentTime).timeString
    }
    
    func startTimer() {
        progressUpdateTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateProgressBar) , userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        progressUpdateTimer.invalidate()
    }

    @IBAction func didPressPlayPause(_ sender: UIBarButtonItem) {
        if audioPlayer.isPlaying {
            toolbar.items![2] = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didPressPlayPause))
            audioPlayer.pause()
            currentPlaybackRate = playRate
            stopTimer()
        } else {
            toolbar.items![2] = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(didPressPlayPause))
            currentPlaybackRate = playRate
            audioPlayer.play()
            startTimer()
        }
    }
    
    @IBAction func didPressFastForward(_ sender: UIBarButtonItem) {
        currentPlaybackRate = fastForwardRate
        toolbar.items![2] = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didPressPlayPause))
        audioPlayer.pause()
        audioPlayer.play()
    }
    
    @IBAction func didPressRewind(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func progressBarDidChange(_ sender: UISlider) {
        audioPlayer.currentTime = TimeInterval(sender.value)
        
        currentTimeLabel.text = audioPlayer.currentTime.timeString
        remainingTimeLabel.text = (audioPlayer.duration - audioPlayer.currentTime).timeString
    }
}

