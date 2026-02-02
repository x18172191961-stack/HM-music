
import { dailyRecommend, recommendList,  swiperList } from "../type/data"
import recommendDailyType from "../type/recommendDailyType"
import recommendListType from "../type/recommendListType"

@Component
export struct Recommend {

  @State swiperList: string[] = []
  @State dailyRecommend: recommendDailyType[] = []
  @State recommendList: recommendListType[] = []

  aboutToAppear(): void {
    this.swiperList = swiperList
    this.dailyRecommend = dailyRecommend
    this.recommendList = recommendList
  }

  @Builder
  naviRow(title: string) {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Text(title).fontColor("#fff6f5f5").fontSize(18).fontWeight(FontWeight.Bold)
      Image($r("app.media.ic_more")).height(20).fillColor("#ffd6d6d6")
    }.margin(10)
  }

  @Builder
  titleBuilder(title: string){
     Row({ }){
       Text(title)
         .height('40')
         .fontSize(14)
         .fontColor(Color.White)

       Image($r('app.media.app_icon'))
         .width(22)
         .height(22)
     }   // 添加以下两个关键属性
     .justifyContent(FlexAlign.SpaceBetween)
     .width('100%')
  }

  build() {
    Scroll(){
      Column({space:10}){
        Row(){
          Image($r('app.media.logo'))
            .width(22)
            .fillColor('#817D83')

          TextInput({placeholder:'只因你太美'})
            .placeholderColor('#817D83')
            .padding({left:5})
            .fontColor('#999')
            .layoutWeight(1)

          Image($r('app.media.logo'))
            .width(22)
            .fillColor('#817D83')
        }
        .width('100%')
        .backgroundColor('#2D2B29')
        .border({radius:20})
        .padding({left:8,right:8})

        Swiper(){
          ForEach(this.swiperList ,(item:string,index: number)=>{
            Image(item)
              .border({radius:10})
              .width('100%')
              .height(220)
          })
        }
        .autoPlay(true)

        // 每日推荐
        this.naviRow("每日推荐")

        List() {
          ForEach(this.dailyRecommend, (item: recommendDailyType) => {
            ListItem(){
              Column(){
                Text(item.type)
                  .width('100%')
                  .height('40')
                  .backgroundColor(item.top)
                  .padding({left:5})
                  .fontSize(14)
                  .fontColor('fff')

                Image(item.img)
                  .width('100%')
                  .layoutWeight(1)

                Text(item.title)
                  .width('100%')
                  .backgroundColor(item.bottom)
                  .padding(5)
                  .fontSize(14)
                  .fontColor('fff')
                  .maxLines(2)
                  .textOverflow({overflow: TextOverflow.Ellipsis})
              }
              .width('40%')
              .height(200)
              .backgroundColor(Color.Red)
              .border({radius:10})
              .margin({right:10})
              .clip(true)
            }
          })
        }.listDirection(Axis.Horizontal).height(230).scrollBar(BarState.Off)

        this.naviRow("推荐歌单")

        List() {
          ForEach(this.recommendList, ((item: recommendListType) => {
            ListItem() {
              Column() {
                Stack() {
                  Image(item.img).width(100).height(100).borderRadius(10)
                  Text(item.count).fontColor(Color.White).fontSize(12).fontWeight(FontWeight.Bold)
                    .padding(10).position({top:0})
                }.width("30%")

                Text(item.title)
                  .fontColor("#ffc8c8c8")
                  .fontSize(12)
                  .padding({ left: 5 })
                  .width("30%")
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .ellipsisMode(EllipsisMode.END)
                  .margin({top:5})
              }
            }
          }))
        }
        .listDirection(Axis.Horizontal)
        .width("100%")
        .height("30%")

      }
      .width('100%')
      // .height('100%')
      .padding(10)
    }  .scrollBar(BarState.Auto)

  }
}