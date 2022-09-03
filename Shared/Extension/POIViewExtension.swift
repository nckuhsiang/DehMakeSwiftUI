//
//  File.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/30.
//

import Foundation

extension PoiView {
    
    func check() -> Bool {
        if title == "" || description == "" || keyword == "" || location.address == ""  {
            print(title,description,keyword,location.address)
            return false
        }
        switch type {
        case .image:
            if (imgManager.imageUrls == nil) {
                print("image error")
                return false
            }
        case .audio:
            if (audioRecorder.audioPath == nil) {
                print("audio error")
                return false
            }
        case .video:
            if (videoManager.videoPath == nil) {
                print("video error")
                return false
            }
        }
        return true
    }
    func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func setPoi(poi:Poi) {
        poi.id = UUID()
        poi.title = title
        poi.keyword = keyword
        poi.longitude = location.longitude
        poi.latitude = location.latitude
        poi.address = location.address
        poi.summary = description
        poi.format = format
        poi.identifier = uvm.role
        poi.language = language
        poi.coi = uvm.coi
        poi.group = (group == "Me".localized ? "" : group)
        poi.rights = uvm.account
        poi.year = Int32(Calendar.current.component(.year, from: Date()))
        //意義不明的欄位
        poi.height = 0
        poi.source = ""
        poi.scope = ""
        poi.open = 0
        poi.subject = "Activation and Reconstructed"
        poi.type = "Natural Landscape"
        poi.period = "現代台灣"
        switch type {
        case .image:
            poi.media_type = "image"
        case .audio:
            poi.media_type = "audio"
        case .video:
            poi.media_type = "video"
        }
        save()
        if let arr = poi.poi_to_media?.allObjects {
            let medias = arr as! [Media]
            for media in medias {
                viewContext.delete(media)
                save()
            }
        }
        switch type {
        case .image:
            poi.media_type = "image"
            for img in imgManager.imageUrls! {
                let media = Media(context: viewContext)
                media.media_to_poi = poi
                media.path = img
                media.format = 1
                media.type = "image"
                save()
            }
        case .audio:
            let media = Media(context: viewContext)
            media.media_to_poi = poi
            media.path = audioRecorder.audioPath
            media.format = 2
            media.type = "audio"
            save()
        case .video:
            let media = Media(context: viewContext)
            media.media_to_poi = poi
            media.path = videoManager.videoPath
            media.format = 4
            media.type = "video"
            save()
        }
        if speakRecorder.audioPath != nil {
            let media = Media(context: viewContext)
            media.media_to_poi = poi
            media.path = speakRecorder.audioPath
            media.format = 8
            media.type = "audio"
            save()
        }
        self.isPresented.wrappedValue.dismiss()
    }
    func updatePoi() {
        
        if check() {
            if self.poi != nil {
                setPoi(poi: self.poi!)
            }
            else {
                let poi = Poi(context: viewContext)
                setPoi(poi: poi)
            }
                
            
        }
        else {
            fieldErrorAlert = true
        }
    }
    
    func initial() {
        if poi != nil {
            title = poi!.title!
            group = poi!.group!
            keyword = poi!.keyword!
            format = poi!.format!
            location.address = poi!.address!
            location.latitude = poi!.latitude!
            location.longitude = poi!.longitude!
            description = poi!.summary!
            if let arr = poi!.poi_to_media?.allObjects {
                let medias = arr as! [Media]
                for media in medias {
                    if media.type == "image" {
                        if imgManager.imageUrls == nil {
                            imgManager.imageUrls = []
                        }
                        imgManager.imageUrls?.append(media.path!)
                    }
                    else if media.type == "video" {
                        videoManager.videoPath = media.path
                        videoManager.initial()
                    }
                    else if media.type == "audio" && media.format == 2 {
                        audioRecorder.initial(path:media.path!)
                    }
                    else {
                        speakRecorder.initial(path:media.path!)
                    }
                    
                }
            }
        }
        
    }
    
    func deleteMedia(format:Int) {
        // delete media
        if poi != nil {
            if let arr = poi!.poi_to_media?.allObjects {
                let medias = arr as! [Media]
                for media in medias {
                    if media.format == format {
                        viewContext.delete(media)
                        save()
                    }
                }
            }
        }
        if format == 1 {
            imgManager.imageUrls = nil
            imgManager.showPictureDialog = false
            imgManager.beyondLimitAlert = false
        }
        else if format == 2 {
            audioRecorder.audioText = "start record audio".localized
            audioRecorder.color = .blue
            audioRecorder.showAudio = false
            audioRecorder.audioPath = nil
            audioRecorder.recording = .record
        }
        else if format == 4 {
            videoManager.showVideoPicker = false
            videoManager.showVideoButton = false
            videoManager.videoText = "start record video".localized
            videoManager.videoPath = nil
            videoManager.playVideo = false
        }
        // format == 8
        else {
            speakRecorder.audioText = "start record audio".localized
            speakRecorder.color = .blue
            speakRecorder.showAudio = false
            speakRecorder.audioPath = nil
            speakRecorder.recording = .record
        }
        
    }
}
