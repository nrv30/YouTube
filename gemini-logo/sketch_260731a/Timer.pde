class Timer {
  private int maxFrames;
  private int framesElapsed;
  
  public Timer(int maxFrames) {
    this.maxFrames = maxFrames;
    framesElapsed = 0;
  }
  
  public boolean updateTimer() {
    framesElapsed++;
    if (framesElapsed == maxFrames) {
      framesElapsed = 0;
      return true;
    }
    else {
      return false;
    }
  }
  
  public void cleanTimer() {
    framesElapsed = 0;
  }
}
