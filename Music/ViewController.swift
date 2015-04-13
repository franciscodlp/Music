//
//  ViewController.swift
//  Music
//
//  Created by Francisco de la Pena on 2/23/15.
//  Copyright (c) 2015 ___QuixoteLabs___. All rights reserved.
//

import UIKit
import AVFoundation

var myAudioPlayer: AVAudioPlayer = AVAudioPlayer()

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var myTimer: NSTimer = NSTimer()
    
    var myTimer2: NSTimer = NSTimer()
    
    @IBOutlet var albumCover: UIImageView!
    
    @IBOutlet var timeControlSlider: UISlider!
    
    @IBOutlet var volumeControlSlider: UISlider!

    @IBAction func playMusic(sender: UIButton) {
        
        play()
    
    }
    
    @IBAction func pauseMusic(sender: UIButton) {
    
        pause()

    }
    
    @IBAction func stopMusic(sender: UIButton) {
        
        stop()
        
    }
    
    
    @IBAction func playBarButton(sender: UIBarButtonItem) {
    
        play()
        
    }
    
    @IBAction func pauseBarButton(sender: UIBarButtonItem) {
        
        pause()
        
    }
    
    @IBAction func stopBarButton(sender: UIBarButtonItem) {

        stop()
        
    }

    
    @IBAction func timeSliderChanged(sender: UISlider) {
        
        myAudioPlayer.currentTime = myAudioPlayer.duration * Double(timeControlSlider.value)
        println("Play from second: \(myAudioPlayer.currentTime)")
        
    }
    
    @IBAction func volumeSliderChanged(sender: UISlider) {
        
        myAudioPlayer.volume = volumeControlSlider.value
        println("Volumen Changed:\(myAudioPlayer.volume)")
        
    }
    
    func play() {
        

        
        myAudioPlayer.prepareToPlay()
        
        myAudioPlayer.play()
        
        myTimer = NSTimer(timeInterval: 1, target: self, selector: "secCounter", userInfo: nil, repeats: true)
        
        NSRunLoop.mainRunLoop().addTimer(myTimer, forMode: NSDefaultRunLoopMode)
        
        myTimer2 = NSTimer(timeInterval: 0.1, target: self, selector: "decimas", userInfo: nil, repeats: true)
        
        NSRunLoop.mainRunLoop().addTimer(myTimer2, forMode: NSDefaultRunLoopMode)
        
        
    }
    
    func pause() {
        
        myAudioPlayer.pause()
        
        myTimer.invalidate()
        
        myTimer2.invalidate()
        
    }
    
    func stop() {
        
        myAudioPlayer.stop()
        
        myAudioPlayer.currentTime = 0.0
        
        timeControlSlider.setValue(0.0, animated: false)
        
        myTimer.invalidate()
        
        myTimer2.invalidate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        println(NSBundle.mainBundle().URLForResource("song2", withExtension: "mp3")!)
        
        var url: NSURL = NSBundle.mainBundle().URLForResource("song2", withExtension: "mp3")!
        
        var error: NSError? = nil
        
        myAudioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        myAudioPlayer.delegate = self
        
        //var asset: AVURLAsset = AVURLAsset.assetWithURL(url) as AVURLAsset
        
        //var myMetaData: [AVMetadataItem] = asset.commonMetadata as [AVMetadataItem]
        
        var asset: AVAsset = AVURLAsset.assetWithURL(url) as! AVURLAsset
        
        var availableMetadataFormats: [String] = asset.availableMetadataFormats as! [String]
        
        var metaDataForAvailableFormats = asset.metadataForFormat(availableMetadataFormats[0])
        
        var commonMetaDataInAsset = asset.commonMetadata
        
        println(commonMetaDataInAsset.count)
        
        var allMetaDataInAsset = asset.metadata
        
        println(allMetaDataInAsset.count)
        
        var imageRawData: NSData = allMetaDataInAsset[4].dataValue
        
        albumCover.image = UIImage(data: imageRawData)
        
        //println(myMetaData.count)
        //println(myMetaData[0].value)
        //println(myMetaData[1].value)
        //println(myMetaData[2].value)
        
        
        //println(AVMetadataFormatID3Metadata)
        //println(AVMetadataID3MetadataKeyTitleDescription)
        //println(AVMetadataID3MetadataKeyAlbumTitle)
        //println(AVMetadataID3MetadataKeyLeadPerformer)
        //println(AVMetadataID3MetadataKeyAttachedPicture)
        
        // Config Sliders
        volumeControlSlider.continuous = false
        volumeControlSlider.maximumValue = 1.0
        volumeControlSlider.minimumValue = 0.0
        volumeControlSlider.setValue(myAudioPlayer.volume, animated: true)
        
        timeControlSlider.continuous = false
        timeControlSlider.maximumValue = 1.0
        timeControlSlider.minimumValue = 0.0
        var cTime = Float(myAudioPlayer.currentTime)
        timeControlSlider.setValue(cTime, animated: true)

    }
    
    func secCounter() {
        
        println(Int(round(myAudioPlayer.currentTime)))
        
    }
    
    func decimas() {
        
        var progress:Float = Float(myAudioPlayer.currentTime) / Float(myAudioPlayer.duration)
        
        println(progress)
        
        timeControlSlider.setValue(progress, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!,
        successfully flag: Bool) {
            
            myTimer.invalidate()
            
            timeControlSlider.setValue(0.0, animated: false)
            
    }


}

