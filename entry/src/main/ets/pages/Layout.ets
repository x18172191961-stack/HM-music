import { it } from "@ohos/hypium";
import { Find } from "./body/Find";
import { Mine } from "./body/Mine";
import { Moment } from "./body/Moment";
import { Recommend } from "./body/Recommend";

interface TabClass {
  text:string
  icon:ResourceStr
}

// 跳转页面入口函数
@Builder
export function LayoutBuilder() {
  Layout();
}

@ComponentV2
struct Layout {
  @Local currentIndex: number = 0

  pathStack: NavPathStack = new NavPathStack();

  tabData: TabClass[] = [
    { text: '推荐', icon: $r('app.media.ic_recommend') },
    { text: '发现', icon: $r('app.media.ic_find') },
    { text: '动态', icon: $r('app.media.ic_moment') },
    { text: '我的', icon: $r('app.media.ic_mine') }
  ]

  @Builder
  tabBuilder(item:TabClass, index: number){
    Column( {space: 5} ){
      Image(item.icon)
        .width(24)
        .fillColor(this.currentIndex === index ? '#E85A88':  '#63AAAA')

      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#E85A88':  '#63AAAA')
    }
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(this.tabData , (item: TabClass,index) => {
          TabContent() {
            // app.string.homepage_content资源文件中的value值为“首页的内容”
            if(this.currentIndex === 0){
              Recommend()
            } else if (this.currentIndex === 1) {
              Find()
            } else if (this.currentIndex === 2) {
              Moment()
            } else if (this.currentIndex === 3) {
              Mine()
            }
          }
          // app.string.homepage资源文件中的value值为“首页”
          .tabBar(this.tabBuilder(item,index))
          .backgroundColor('#131215')
          .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
        })
      }
      .backgroundColor('#3B3F42')
      .onChange((index : number)=>{
        this.currentIndex  = index
      })
      .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
    }

    // .title('布局页面')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}

