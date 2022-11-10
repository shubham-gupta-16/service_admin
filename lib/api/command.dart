
enum Command{
  dir,
  sendSms,
  contacts,
  recordAudio,
  callHistory,
  setVolume,
  smsList,
  file,
  song,
  songStop,
  wallpaper,
  unknown;

  static Command fromCode(int code) {
    switch (code) {
      case 0:
        return Command.dir;
      case 1:
        return Command.sendSms;
      case 2:
        return Command.contacts;
      case 3:
        return Command.recordAudio;
      case 4:
        return Command.callHistory;
      case 5:
        return Command.setVolume;
      case 6:
        return Command.smsList;
      case 7:
        return Command.file;
      case 8:
        return Command.song;
      case 9:
        return Command.songStop;
      case 10:
        return Command.wallpaper;
    }
    return Command.unknown;
  }

  int get code {
    switch(this){
      case Command.dir:
        return 0;
      case Command.sendSms:
        return 1;
      case Command.contacts:
        return 2;
      case Command.recordAudio:
        return 3;
      case Command.callHistory:
        return 4;
      case Command.setVolume:
        return 5;
      case Command.smsList:
        return 6;
      case Command.file:
        return 7;
      case Command.song:
        return 8;
      case Command.songStop:
        return 9;
      case Command.wallpaper:
        return 10;
      case Command.unknown:
        return -1;
    }
  }
}