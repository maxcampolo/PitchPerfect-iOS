//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Max Campolo on 3/12/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the av player
        loadAVPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func loadAVPlayer() {
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: &error);
        
        audioPlayer.enableRate = true
        
        // Load audio engine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error:nil)
    }
    
    // MARK: - Action
    
    @IBAction func playSlow(sender: UIButton) {
        // Play the clip at a slow speed
        playAudioWithRate(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        // Play the clip at a slow speed
        playAudioWithRate(1.5)
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // MARK: - Helper
    
    func playAudioWithRate(rate: Float) {
        // Stop the audio engine
        audioEngine.stop()
        audioEngine.reset()
        // Stop and reset the player
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        // Set the rate and play
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
