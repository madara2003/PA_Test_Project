sub init()
    m.rowListOfCars = m.top.findNode("RListOfCars")
    m.rowListOfCars.setFocus(true)
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.infoLable = m.top.findNode("infoAboutTesting")
    m.genre = m.top.findNode("genre")
    m.description = m.top.findNode("descriptionOfCars")
    m.secondScreen = m.top.findNode("secondScreen")
    m.blendAnimation = m.top.findNode("blendAnimation")

    m.rowListOfCars.observeField("rowItemFocused", "changeHomeScreenContent")
    m.rowListOfCars.observeField("itemSelected", "changeVisibilityOfComponents")
   
    m.infoLable.font.size = 36
    m.infoLable.font = "font:LargeBoldSystemFont" 
 
    m.genre.text = "Genre: motoring | 0 year"
    m.genre.font.size = 16

    m.description.font.size =16
    m.description.font = "font:SmallestBoldSystemFont" 
 
    taskNode = CreateObject("RoSGNode", "TaskNode")
    taskNode.observeField("responseData", "handleResponse")
    taskNode.control = "run"
    m.indexOfPrevItem = [0, 0]
 end sub
 
 function handleResponse(event)
   data = event.getData()
   content = CreateObject("RoSGNode","ContentNode")
   row = content.createChild("ContentNode") 
   rowItemSize = [[280, 140]]
   dataofChannel =  data["rss"][0]["channel"]
   count = 0
   For Each itemofChanel in dataofChannel 
       if itemofChanel.DoesExist("item")
          rowItem = row.createChild("ContentNode")
          itemData = itemOfChanel["item"]
        For Each item in itemData  
           if item.DoesExist("media:thumbnail") 
              media = item["attributes"]
              mediaUrl = media.url.Replace("300x168.jpg", "1280x720.jpg")
              rowItem.Description = mediaUrl
              count++
              rowItem.addField("isPlayed", "boolean", false)
           else if item.DoesExist("description")
              rowItem.Title = item["description"]
           else if item.DoesExist("title")
              rowItem.TitleSeason = item["title"]
           else if item.DoesExist("media:title")
               rowItem.TitleSeason = item["media:title"]
               rowItem.HDBranded = false
                sec = CreateObject("roRegistrySection", "Favorites")
                keys =  sec.GetKeyList() 
            if  sec.Exists(rowItem.TitleSeason )
                rowItem.HDBranded = true
            end if
           else if item.DoesExist("media:content")
                videoUrl = item["attributes"]
                rowItem.Url = videoUrl.url  
                duration = videoUrl.duration.toInt()
                rowItem.PlayDuration = duration                    
           End if 
         End For  
       End if
    End For  
    row.TITLE = data["rss"][0]["channel"][0].title
    m.rowListOfCars.rowLabelFont = "font:MediumBoldSystemFont"
    m.rowListOfCars.rowItemSize = rowItemSize
    m.rowListOfCars.translation = [40,470]
    m.rowListOfCars.itemSize = [1228, 180] 
    m.rowListOfCars.rowLabelColor = "#dc143c"
    m.rowListOfCars.rowLabelOffset = [0, 15]
    m.rowListOfCars.rowItemSpacing =[30, 0]
    m.rowListOfCars.content = content
 end function
  
Function updateFavoriteData(key)
    sec = CreateObject("roRegistrySection", "Favorites")
    if not m.currentElement.HDBranded 
      sec.write(key, "true")
      sec.Flush()
      m.currentElement.HDBranded = true
    else 
      sec.Delete(key)
      m.currentElement.HDBranded = not m.currentElement.HDBranded
    end if
End Function

function changeHomeScreenContent(event)
     prevItem = m.rowListOfCars.content.getChild(m.indexOfPrevItem[0]).getChild(m.indexOfPrevItem[1])
     prevItem.isPlayed = false 
     m.blendAnimation.control = "start"
     indexofRowItem = event.getData()
     m.rowListOfCars.content.getChild(indexofRowItem[0]).getChild(indexofRowItem[1]).isPlayed = true
     m.currentElement = m.rowListOfCars.content.getChild(indexofRowItem[0]).getChild(indexofRowItem[1])
     m.currentElement.isPlayed = true
     m.indexOfPrevItem = [indexofRowItem[0], indexofRowItem[1]]
     m.infoLable.text = m.currentElement.TitleSeason
     m.description.text = m.currentElement.Title
     m.backgroundPoster.uri = m.currentElement.Description  
     m.secondScreen.dataSecondScreen = m.currentElement   
     m.currentElement.isPlayed = true
 end function 

 function changeVisibilityOfComponents()
     m.currentElement.isPlayed = false
     m.secondScreen.videoSetter = true
     m.secondScreen.setFocus(true)
     m.secondScreen.setFocusVideo = true
     m.secondScreen.visible = true  
 end function 

 function setFocusSecondScreen()
   m.rowListOfCars.setFocus(false)
   m.secondScreen.setFocus(true)
 end function
 
 function OnKeyEvent(key, press) as boolean
    result = true
    if key = "back" 
      if m.secondScreen.visible
         m.secondScreen.visible = false
         m.currentElement.isPlayed = true
         m.rowListOfCars.setFocus(true)
       return true
      end if
     end if  
     if key = "options"
       if not press 
         updateFavoriteData(m.currentElement.TitleSeason)
       end if 
     end if
    return result
 end function