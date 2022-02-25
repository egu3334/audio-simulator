import java.util.ArrayList;

public class Station {
  
    int cooldown;
    int delay;
    boolean busy;
    boolean eventAvailable;
    ArrayList<Notification> events = new ArrayList<Notification>();
  
    public Station() {
        cooldown = 0;
        delay = 0;
        busy = false;
        eventAvailable = false;
    }
    
    public void reduceCooldown(int diff) {
      if (busy) {
        cooldown -= diff;
        if (cooldown <= 0) {
            cooldown = 0;
            busy = false;
        }
      }
    }
    
    public void triggerEvent(int timeCost) {
      busy = true;
      eventAvailable = false;
      cooldown += timeCost;
    }
    
    public void receiveEvent() {
      eventAvailable = true;
    }
    
    public int getCooldown() {
      return cooldown;
    }
    
    public int getDelay() {
      return delay;
    }
    
    public boolean getBusy() {
      return busy;
    }
    
    public boolean getEventAvailable() {
      return eventAvailable;
    }
    
    public ArrayList<Notification> getEvents() {
      return events;
    }
    
    
  
}
