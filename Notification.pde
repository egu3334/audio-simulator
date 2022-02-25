public class Notification {
   
  int type;
  public int timestamp;
  int priority;
  boolean resMade;
  int tableNumber;
  String initials;
  
  public Notification(JSONObject json) {
    this.type = json.getInt("type");
    this.priority = json.getInt("priority");
    this.timestamp = json.getInt("timestamp");
    
    if (!json.isNull("resmade")) {
      this.resMade = json.getBoolean("resmade");  
    } else {
      resMade = false;
    }
    
    if (!json.isNull("tablenumber")) {
      this.tableNumber = json.getInt("tablenumber");
    } else {
      tableNumber = -1;
    }
    
    if (!json.isNull("initials")) {
      this.initials = json.getString("initials");
    } else {
      initials = "";
    }

  }
  
  public int getType() { return type; }
  public int getTimestamp() { return timestamp; }
  public int getPriority() { return priority; }
  public Boolean getResMade() { return resMade; }
  public int getTableNumber() { return tableNumber; }
  public String getInitials() { return initials; }
  
  public String toString() {
     return "";
  }
}
