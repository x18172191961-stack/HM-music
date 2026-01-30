// 跳转页面入口函数
@Builder
export function StartBuilder() {
  Start();
}

@Component
struct Start {
  @State Countdown:number=5
  private timer?: number
  pathStack: NavPathStack = new NavPathStack();

  // 页面打开 计算时间3秒
  // aboutToAppear(): void {
  //     setTimeout(()=> {
  //       this.pathStack.replacePathByName('Layout',null,false)
  //     },3000)
  // }

  private jumped = false

  private jump() {
    if (this.jumped) return
    this.jumped = true

    if (this.timer) {
      clearInterval(this.timer)
      this.timer = undefined
    }

    this.pathStack.replacePathByName('Layout',null,false)
  }

  aboutToAppear() {
    this.timer = setInterval(() => {
      if (this.Countdown <= 0) {
        this.jump()
      } else {
        this.Countdown--
      }
    }, 1000)
  }

  aboutToDisappear() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = undefined
    }
  }

  build() {
    NavDestination() {
      Stack({alignContent:Alignment.TopEnd}) {
        Image($r("app.media.bg"))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
        Text(`跳过 ${this.Countdown}`).position({top:0,right:0}).margin(20).padding(5)
          .backgroundColor("#ff858585").fontColor("#ffe0e0e0")
          .width(60) .textAlign(TextAlign.Center)
          .borderRadius("30%")
          .onClick(()=>{
            this.jump()
          })
      }
    }

    // .title('广告页面')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}