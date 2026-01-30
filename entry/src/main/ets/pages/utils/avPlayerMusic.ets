import { media } from '@kit.MediaKit';
import { GlobalMusic } from '../type/GlobalMusic';
import { AppStorageV2 } from '@kit.ArkUI';
import { SongItemType } from '../type/SongItemType';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { SessionManager } from './AVSessionManager';

class avPlayerMusic {
  GlobalMusic: GlobalMusic = AppStorageV2.connect(GlobalMusic, "GlobalMusic", () => new GlobalMusic())!
  avPlayer: media.AVPlayer | null = null

  async init() {
    if (!this.avPlayer) {
      try {
        this.avPlayer = await media.createAVPlayer();
        this.avPlayer.on('stateChange', (state: string) => {

          if (state === "initialized") {
            this.avPlayer?.prepare().catch(() => {
              // TODO: Implement error handling.
            })
          } else if (state === "prepared") {
            this.avPlayer?.play().catch(() => {
              // TODO: Implement error handling.
            })
          } else if (state === "completed") {
            this.nextSong()
          } else if (state === "released") {
            this.release()
          }
        });
        //音频播放时长更新时触发
        this.avPlayer.on('durationUpdate', (duration: number) => {
          // 开发者根据需要写入业务逻辑。
          this.GlobalMusic.duration = duration
          SessionManager.SetMetaData(this.GlobalMusic.playList[this.GlobalMusic.currentMusic])
        });

        //播放时间更新时触发
        this.avPlayer.on('timeUpdate', (time: number) => {
          // 开发者根据需要写入业务逻辑。
          this.GlobalMusic.time = time
          SessionManager.setPlaybackStatus()

        });
      } catch (error) {
        // TODO: Implement error handling.
        console.error(error)
      }
    }
  }

  //切歌
  async changePlay() {
    await this.avPlayer?.reset()
    this.GlobalMusic.time = 0
    this.GlobalMusic.duration = 0
    this.GlobalMusic.url = this.GlobalMusic.playList[this.GlobalMusic.currentMusic].url
    this.GlobalMusic.img = this.GlobalMusic.playList[this.GlobalMusic.currentMusic].img
    this.GlobalMusic.name = this.GlobalMusic.playList[this.GlobalMusic.currentMusic].name
    this.GlobalMusic.author = this.GlobalMusic.playList[this.GlobalMusic.currentMusic].author
    this.avPlayer!.url = this.GlobalMusic.url
    this.avPlayer?.play()
  }

  //上一首
  preSong() {

    if (this.GlobalMusic.playbackStatus === "顺序播放" || this.GlobalMusic.playbackStatus === "随机播放") {
      if (this.GlobalMusic.currentMusic <= 0) {
        this.GlobalMusic.currentMusic = this.GlobalMusic.playList.length - 1
        this.changePlay()
      } else {
        this.GlobalMusic.currentMusic--
        this.changePlay()
      }
    } else {
      //单曲循环
      this.avPlayer?.play()
    }
    SessionManager.setPlaybackStatus()
  }

  //下一首
  nextSong() {

    if (this.GlobalMusic.playbackStatus === "顺序播放") {
      //顺序播放
      if (this.GlobalMusic.currentMusic >= this.GlobalMusic.playList.length - 1) {
        this.GlobalMusic.currentMusic = 0
        this.changePlay()
      } else {
        this.GlobalMusic.currentMusic++
        this.changePlay()
      }
    } else if (this.GlobalMusic.playbackStatus === "单曲循环") {
      //单曲循环
      this.avPlayer?.play()
    } else {
      let old: number = 0
      //随机播放
      this.GlobalMusic.currentMusic = Math.floor(Math.random() * this.GlobalMusic.playList.length)
      if (old == this.GlobalMusic.currentMusic && this.GlobalMusic.playList.length > 1) {
        this.GlobalMusic.currentMusic = Math.floor(Math.random() * this.GlobalMusic.playList.length)
      } else {
        old = this.GlobalMusic.currentMusic
        this.changePlay()
      }
    }
    SessionManager.setPlaybackStatus()

  }

  //暂停或继续播放
  stopOrContinueSong() {

    if (this.GlobalMusic.isPlay) {
      this.GlobalMusic.isPlay = !this.GlobalMusic.isPlay
      this.avPlayer?.pause()
    } else {
      this.GlobalMusic.isPlay = !this.GlobalMusic.isPlay
      this.avPlayer?.play()
    }
    SessionManager.setPlaybackStatus()
  }

  playResources(Song: SongItemType) {
    SessionManager.startContinuousTask()
    SessionManager.setPlaybackStatus()
    const isPlay = this.GlobalMusic.playList.some(item => item.id === Song.id)
    //hilog.info(0x0000, "ss",isPlay+"");
    if (isPlay) {

      if (Song.url === this.GlobalMusic.url) {
        this.avPlayer?.play()

      } else {
        this.GlobalMusic.currentMusic = this.GlobalMusic.playList.findIndex(item => item.id === Song.id)
        hilog.info(0x0000, "ss", "切换索引" + this.GlobalMusic.playList.findIndex(item => item.id === Song.id));
        hilog.info(0x0000, "ss", "切换播放");
        //切换播放
        this.changePlay()
      }
    } else {
      this.GlobalMusic.playList.unshift(Song)
      this.GlobalMusic.currentMusic = 0
      hilog.info(0x0000, "ss", "新增播放");
      //切换播放
      this.changePlay()

    }
    if (!this.GlobalMusic.isShowPlayBar) {
      let timer: number | undefined;
      timer = setInterval(() => {
        this.GlobalMusic.isShowPlayBar = !this.GlobalMusic.isShowPlayBar;
        clearInterval(timer)
      }, 600)

    }
    // hilog.info(0x0000, "ss", "当前索引值"+this.GlobalMusic.currentMusic);
    // hilog.info(0x0000, "ss",this.GlobalMusic.name);
  }

  jumpToPlay(jumpToTime: number) {
    this.avPlayer?.seek(jumpToTime)
  }
  //
  deleteSong(index:number){
    this.GlobalMusic.playList.splice(index,1)
  }
  async release() {
    await this.avPlayer?.release()
  }
}

export const avPlayerManage: avPlayerMusic = new avPlayerMusic()



