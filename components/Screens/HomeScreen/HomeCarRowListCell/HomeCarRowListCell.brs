sub init()
    m.automobilePoster = m.top.findNode("PosterOfCar") 
    m.video = m.top.findNode("cellVideo")
    m.carVideoAnimation = m.top.findNode("carVideoAnimation")
    m.favorites = m.top.findNode("Favorites")
    m.video.observeField("state", "changeAfterBuffering")
    m.animationVideo = m.top.findNode("animationVideo")
    m.video.loop = true
end sub

function onItemFocus()
   if m.top.itemHasFocus = true
      m.valueofFirstKey = 1.0
   end if
end function

function fireAnimation()
   if m.top.focusPercent = 0.0
       m.carVideoAnimation.control = "start" 
       m.animationVideo.keyValue = [m.valueofFirstKey , 1.0]
    else 
   end if 
end function

function changeAfterBuffering(event)
      bufferingEvent = event.getData()
      if bufferingEvent = "playing"  
         m.automobilePoster.visible = false
         m.favorites.visible = false
         m.valueofFirstKey = 0.0  
      else if bufferingEvent = "stop"
      else
         m.valueofFirstKey = 1.0
         m.automobilePoster.visible = true
         m.favorites.visible = true
      end if
end function

function displayCarsImages()
   carImages = m.top.itemContent
   resolutionCellImage = carImages.Description.Replace("1280x720.jpg", "280x140.jpg")
   m.automobilePoster.uri = resolutionCellImage 
   m.automobilePoster.width = 280
   m.automobilePoster.height = 140
   if not carImages.HDBranded
      m.favorites.uri ="pkg:/images/icActiveDislike.png"
   else if carImages.HDBranded
      m.favorites.uri = "pkg:/images/icActiveLike.png"
   end if
   carImages = m.top.itemContent
   videoContent = createObject("RoSGNode", "ContentNode")
   videoContent.streamformat = "hls"
   videoContent.url = carImages.Url   
   m.video.content = videoContent
   if carImages.isPlayed = false 
      m.opacity = 0.0
   else    
   end if 
    if not carImages.isPlayed 
      m.video.control = "stop"
    else 
      m.video.control = "play"
   end if
end function