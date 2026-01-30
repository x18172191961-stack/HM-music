import { SongItemType } from "../../models/music"
import { AppStorageV2 } from "@kit.ArkUI"
import { songsList } from "../type/data"
import { GlobalMusic } from "../type/GlobalMusic"
import { avPlayerManage } from "../utils/avPlayerMusic"


@Component
export struct Find {
  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack,'navStack',()=>new NavPathStack())!
  GlobalMusic:GlobalMusic = AppStorageV2.connect(GlobalMusic,"GlobalMusic",()=> new GlobalMusic())!
  songs: SongItemType[]=songsList

  build() {
    Column(){
      List(){
        ForEach(this.songs,((item:SongItemType,index:number)=>{
          ListItem(){
            Flex({alignItems:ItemAlign.Center}){
              Row(){
                Image(item.img).width("30%").borderRadius(15).margin(5)
                Column({space:15}){
                  Text(item.name).fontColor(Color.White).fontWeight(FontWeight.Bold)

                  Flex({alignItems:ItemAlign.Center}){
                    Text("vip").border({width:1,color:"#837F41",radius:"40%"}).fontColor("#837F41").width(35)
                      .textAlign(TextAlign.Center)
                    Text(item.author).fontColor("#ff9d9d9d").height(30).margin({left:10})
                  }
                }.margin({left:5}).alignItems(HorizontalAlign.Start)

                .onClick(()=>{
                  if (this.GlobalMusic.playList.length<=0) {
                    this.GlobalMusic.playList=this.songs
                  }
                  avPlayerManage.playResources(item)
                  this.pathStack.pushPathByName("play",item)
                })
              }.margin(5) .justifyContent(FlexAlign.Center)
              Image($r("app.media.ic_more")).height(30)
                .fillColor(Color.White).margin({right:5})
            }
          }
        }))
      }.width("100%").height("100%")
    }
    .width('100%')
    .height('100%')
    .padding({left:10,right:10})
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}