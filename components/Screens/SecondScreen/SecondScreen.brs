sub init()
   m.top.setFocus(true)
   m.button = m.top.findNode("button")
   m.button.observeField("buttonSelected", "onSelectButton")
   m.bgPoster = m.top.findNode("bgPoster")
   m.title = m.top.findNode("title")
   m.title.font.size = 32
   m.titleText = m.top.findNode("titleText")
   m.titleText.font.size = 18  
   m.description = m.top.findNode("description")
   m.description.font.size = 32
   m.descriptionText = m.top.findNode("descriptionText")
   m.descriptionText.font.size = 18
   m.translationAnimation = m.top.findNode("translationAnimation")
   m.widthAnimation = m.top.findNode("widthAnimation")
   m.heightAnimation = m.top.findNode("heightAnimation")
   m.videoFocus = m.top.findNode("videoFocus")
   m.interpTranslation = m.top.findNode("interpTranslation")
   m.interpWidth = m.top.findNode("interpWidth")
   m.interpheight = m.top.findNode("interpheight")
   displayDepandsOnMode()
end sub

function customizeButton()
   if m.top.trigger 
      m.button.text = "Remove from favorites"
      m.button.textColor = "#FFFF00"
    else 
       m.button.text = "Add to favorites"
       m.button.textColor = "#000080"
    end if 
end function


function displayDepandsOnMode()
    di = CreateObject("roDeviceInfo")
    if di.GetDisplayMode() = "720p"
      m.bgPoster.width = 1280
      m.bgPoster.height= 720
    else 
      m.bgPoster.width = 1920
      m.bgPoster.height = 1080
    end if
  end function

function onSelectButton()
  
   sec = CreateObject("roRegistrySection", "Favorites")
   if m.top.trigger 
      sec.Delete(m.top.key)
      m.top.trigger = false
      m.top.dislikeButton= false
      m.top.buttonSelected = false
   else   
      m.top.buttonSelected = true
     sec.write(m.top.key, "true")
     sec.Flush()
     m.button.textColor = "#006400"
     m.button.focusedTextColor = "#006400"
     m.top.dislikeButton= true
     m.top.trigger = true
   end if 
end function 

function setAnimationVideo()
   m.video.translation = [800,150]
   m.interpTranslation.key = [0.0, 1.0]
   m.interpTranslation.keyValue =  [[800, 150], [0, 0]]
   m.interpWidth.key = [0.0, 1.0]
   m.interpWidth.keyValue = [477.0, 1280.0]
   m.interpheight.key = [0.0, 1.0]
   m.interpheight.keyValue = [300.0, 720.0]
   m.translationAnimation.control = "start"
   m.widthAnimation.control = "start"
   m.heightAnimation.control = "start"
   m.videoFocus.visible = false
   m.button.visible = false
   m.video.setFocus(true)
end function

function customizeSecondScreen()
   m.titleText.text = m.top.dataSecondScreen.TitleSeason
   m.descriptionText.text = m.top.dataSecondScreen.Title
   m.bgPoster.uri =  m.top.dataSecondScreen.Description
   videoContent = createObject("RoSGNode", "ContentNode")
   videoContent.url = m.top.dataSecondScreen.Url
   videoContent.streamformat = "hls"
   m.video = m.top.findNode("filmVideo")
   m.video.observeField("state", "setAnimation")
   m.video.content = videoContent
end function

function videoSetter()
   if m.top.videoSetter
      m.video.control = "play"
   else 
      m.video.control = "stop"
   end if 
end function

function setAnimation()
    if m.video.state = "finished" And m.video.translation[0] = 0
        m.video.control = "play"
        m.video.loop = true
        animationFullVideo()
        m.video.setFocus(false)
        m.top.setFocus(true)
    end if
end function

function animationFullVideo()
   m.videoFocus.visible = true
   m.interpTranslation.key = [0.0, 1.0]
   m.interpTranslation.keyValue = [[0, 0], [800, 150]]
   m.interpWidth.key = [0.0, 1.0]
   m.interpWidth.keyValue = [1280.0, 450.0]
   m.interpheight.key = [0.0, 1.0]
   m.interpheight.keyValue = [720.0, 300.0]
   m.button.visible = true
   m.translationAnimation.control = "start"
   m.widthAnimation.control = "start"
   m.heightAnimation.control = "start"
end function

function OnKeyEvent(key, press) as boolean
      handle = true
      if key = "OK"
      if m.video.translation[0] = 800 AND not m.button.hasFocus() 
         m.video.loop = false
         if not m.top.animationTrigger
            m.top.animationTrigger = true
            handle = true    
         else if m.top.animationTrigger
            m.video.loop = false
            setAnimationVideo()
            handle = true
        end if 
       end if
     end if
     if key = "back"
      if m.video.translation[0] <> 0 AND m.video.translation[0] <> 800
         handle = true
      end if
      if m.video.translation[0] = 800
         m.videoFocus.visible = true
         m.top.animationTrigger = false
         handle = false
      else if m.video.translation[0] = 0
         m.video.setFocus(false)
         m.top.setFocus(true)
         animationFullVideo()
         handle = true    
       end if
      end if
      if key = "down"
        if m.video.translation[0] = 800
             if  m.videoFocus.visible
             m.button.setFocus(true)
             if m.button.hasFocus()
               m.videoFocus.visible = false
             end if
         end if
        end if
      end if
      if key = "left"
         m.descriptionText.setFocus(true)
         m.videoFocus.visible = false
      end if 
      if key = "right"
         m.button.setFocus(true)
      end if 
      if key = "up"
        if  m.video.translation[0] = 800
         if m.button.hasFocus()
          m.button.setFocus(false)
          m.top.setFocus(true)
          if not m.button.hasFocus() 
            m.videoFocus.visible = true
          end if
        end if
       end if
      end if
          return handle
end function