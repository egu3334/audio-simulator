import controlP5.*;
import beads.*;
import guru.ttslib.*;
import java.util.*;

JSONArray testData;
Station[] stations;
//stations 0-3 - tables 1-4
//station 4 kitchen
//station 5 other employees

ArrayList<Notification> ongoingEvents;
ArrayList<Notification> incEvents;
Notification notification;
Notification curr;

TTS tts;

ControlP5 p5;

SamplePlayer music;
SamplePlayer clean;
SamplePlayer clearPlates;
SamplePlayer customerArrival;
SamplePlayer deliverBill;
SamplePlayer employeeAssistance;
SamplePlayer foodPrepared;
SamplePlayer question;
SamplePlayer readyToOrder;
SamplePlayer refill;

Glide mainGlide;

Gain masterGain;
Gain prioGain;

BiquadFilter reserveFilter;

Bead endListener;

Button playButton;

Panner pan;

int count = 0;
int time;
int cd;
int visual;
int customerNumber = 0;

int waveCount = 50;
float baseFrequency = 440.0;

Glide[] waveFrequency = new Glide[waveCount];
Gain[] waveGain = new Gain[waveCount];
Gain masterWaveGain;
WavePlayer[] waveTone = new WavePlayer[waveCount];

//end global variables

void setup() {
  size(1000, 1000); 
  
  float waveIntensity = 1.0;
  
  testData = loadJSONArray("scenario2.json");
  
  stations = new Station[6];
  for (int i = 0; i < 6; i++) {
    stations[i] = new Station();
  }
  
  for (int i = 0; i < testData.size(); i++) {
     JSONObject o = testData.getJSONObject(i); 
     
     if (o.getInt("type") != 3 && o.getInt("type") != 9) {
       stations[o.getInt("tablenumber") - 1].events.add(new Notification(o));
     } else if (o.getInt("type") == 3) {
       stations[4].events.add(new Notification(o));
     } else if (o.getInt("type") == 9) {
       stations[5].events.add(new Notification(o));
     }
  }
/*  
  Comparator<Notification> priorityComp = new Comparator<Notification>() {
    public int compare(Notification n1, Notification n2) {
      if (n1.getPriority() != n2.getPriority()) {
        return max(n1.getPriority(), n2.getPriority());
      }
      return min(n1.getTimestamp(), n2.getTimestamp());
    }
  };

  Comparator<Notification> timeComp = new Comparator<Notification>() {
     public int compare(Notification n1, Notification n2) {
      return min(n1.getTimestamp(), n2.getTimestamp());
    }
  };
  */
  ongoingEvents = new ArrayList<Notification>();
  incEvents = new ArrayList<Notification>();
  
  tts = new TTS();
  
  ac = new AudioContext(); 
  
  p5 = new ControlP5(this);
  
  clean = getSamplePlayer("clean.wav");
  clean.pause(true);
  
  clearPlates = getSamplePlayer("clear plates.wav");
  clearPlates.pause(true);
  
  customerArrival = getSamplePlayer("customer arrival.wav");
  customerArrival.pause(true);
  
  deliverBill = getSamplePlayer("deliver bill.wav");
  deliverBill.pause(true);
  
  employeeAssistance = getSamplePlayer("employee assistance.wav");
  employeeAssistance.pause(true);
  
  foodPrepared = getSamplePlayer("food prepared.wav");
  foodPrepared.pause(true);
  
  question = getSamplePlayer("question.wav");
  question.pause(true);
  
  readyToOrder = getSamplePlayer("ready to order.wav");
  readyToOrder.pause(true);
  
  refill = getSamplePlayer("refill.wav");
  refill.pause(true);
  
  mainGlide = new Glide(ac, 0.5, 200);
  masterGain = new Gain(ac, 1, mainGlide);
  
  prioGain = new Gain(ac, 1, 0.5);
  
  reserveFilter = new BiquadFilter(ac, BiquadFilter.AP, 1000.0, 0.5f);
  reserveFilter.addInput(customerArrival);
  
  masterWaveGain = new Gain(ac, 1, 0);
  
  for( int i = 0, n = 1; i < waveCount; i++, n++) {
    
    waveFrequency[i] = new Glide(ac, baseFrequency * n, 200);
    waveTone[i] = new WavePlayer(ac, waveFrequency[i], Buffer.SINE);
    
    waveIntensity = n == 1 ? 1.0 : 0;  
    
    waveGain[i] = new Gain(ac, 1, waveIntensity); 
    waveGain[i].addInput(waveTone[i]); 
  
    masterWaveGain.addInput(waveGain[i]);
  }
  
  prioGain.addInput(clean);
  prioGain.addInput(clearPlates);
  prioGain.addInput(reserveFilter);
  prioGain.addInput(deliverBill);
  prioGain.addInput(employeeAssistance);
  prioGain.addInput(foodPrepared);
  prioGain.addInput(question);
  prioGain.addInput(readyToOrder);
  prioGain.addInput(refill);
  
  masterGain.addInput(prioGain);
  masterGain.addInput(masterWaveGain);
  
  ac.out.addInput(masterGain);
 /* 
  playButton = p5.addButton("Play")
    .setPosition(width / 2, 30)
    .setSize(width/3, 20)
    .setLabel("Play")
    .setColorBackground(color(65, 105, 225));
    */
    
  playButton = p5.addButton("Entrance")
    .setPosition(100, 500)
    .setSize(90, 150)
    .setLabel("Entrance")
    .setColorBackground(color(65, 105, 225));
  
  playButton = p5.addButton("Table1")
    .setPosition(300, 300)
    .setSize(100, 100)
    .setLabel("Table1")
    .setColorBackground(color(65, 105, 225));
    
  playButton = p5.addButton("Table2")
    .setPosition(300, 700)
    .setSize(100, 100)
    .setLabel("Table2")
    .setColorBackground(color(65, 105, 225));
    
  playButton = p5.addButton("Table3")
    .setPosition(700, 300)
    .setSize(100, 100)
    .setLabel("Table 3")
    .setColorBackground(color(65, 105, 225));
    
  playButton = p5.addButton("Table4")
    .setPosition(700, 700)
    .setSize(100, 100)
    .setLabel("Table 4")
    .setColorBackground(color(65, 105, 225));
    
  playButton = p5.addButton("Kitchen")
    .setPosition(300, 100)
    .setSize(500, 100)
    .setLabel("Kitchen")
    .setColorBackground(color(65, 105, 225));
    
  playButton = p5.addButton("Employees")
    .setPosition(900, 450)
    .setSize(80, 80)
    .setLabel("Employees")
    .setColorBackground(color(65, 105, 225));
    
  p5.addSlider("GainSlider")
    .setPosition(20, 50)
    .setSize(20, 200)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("Gain Slider");
    
  playButton = p5.addButton("Busyness")
    .setPosition(800, 900)
    .setSize(100, 40)
    .setLabel("Busyness")
    .setColorBackground(color(65, 105, 225));
    
  ac.start();
                  
}

public void Play(int value) {
  playReadyToOrder(1, 3);
}

public void Entrance(int value) {
  Notification n = checkExistence(0);
  if (n != null) {
    stations[n.getTableNumber() - 1].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
    customerNumber++;
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Table1(int value) {
  Notification n = checkExistence(1);
  if (n != null) {
    stations[0].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Table2(int value) {
  Notification n = checkExistence(2);
  if (n != null) {
    stations[1].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Table3(int value) {
  Notification n = checkExistence(3);
  if (n != null) {
    stations[2].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Table4(int value) {
  Notification n = checkExistence(4);
  if (n != null) {
    stations[3].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Kitchen (int value) {
  Notification n = checkExistence(5);
  if (n != null) {
    stations[4].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public void Employees(int value) {
  Notification n = checkExistence(6);
  if (n != null) {
    stations[5].triggerEvent(3000);
    fill(0, 255, 0);
    ellipse(900, 95, 50,50);
    println("Event completed.");
  } else {
    fill(255, 0, 0);
    ellipse(900, 95, 50,50);
  }
  visual = 200;
}

public Notification checkExistence(int station) {
  if (ongoingEvents.isEmpty()) {
    return null;
  }
  Notification check = null;
  if (station == 0) {
    for (Notification n: ongoingEvents) {
      if (n.getType() == 1) {
        check = n;
      }
    }
  } else if (station == 5) {
    for (Notification n: ongoingEvents) {
      if (n.getType() == 3) {
        check = n;
      }
    }
  } else if (station == 6) {
    for (Notification n: ongoingEvents) {
      if (n.getType() == 9) {
        check = n;
      }
    }
  } else {
    for (Notification n: ongoingEvents) {
      if (n.getTableNumber() == station && n.getType() != 1) {
        check = n;
      }
    }
  }
  if (check != null) {
    return check;
  }
  return null;
}

public void GainSlider(float value) {
  mainGlide.setValue(value/100.0);
}

public void playSound(Notification n) {
  if (n.getType() == 1) {
    playCustomerArrival(n.getResMade(), n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 2) {
    playReadyToOrder(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 3) {
    playFoodPrepared(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 4) {
    playQuestion(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 5) {
    playRefill(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 6) {
    playClearPlates(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 7) {
    playDeliverBill(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 8) {
    playClean(n.getTableNumber(), n.getPriority());
  } else if (n.getType() == 9) {
    playEmployeeAssistance(n.getInitials(), n.getPriority());
  }
}

public void playCustomerArrival(boolean resMade, int tableNumber, int prio) {
  if (!resMade) {
    reserveFilter.setType(BiquadFilter.LP);
  } else {
    reserveFilter.setType(BiquadFilter.AP);
  }
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  customerArrival.setToLoopStart();
  customerArrival.start();
}

public void playReadyToOrder(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  readyToOrder.setToLoopStart();
  readyToOrder.start();
  tts.speak("" + tableNumber);
  
}

public void playFoodPrepared(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  foodPrepared.setToLoopStart();
  foodPrepared.start();
  tts.speak("" + tableNumber);
}

public void playQuestion(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  question.setToLoopStart();
  question.start();
  tts.speak("" + tableNumber);
}

public void playRefill(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  refill.setToLoopStart();
  refill.start();
  tts.speak("" + tableNumber);
}

public void playClearPlates(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  clearPlates.setToLoopStart();
  clearPlates.start();
  tts.speak("" + tableNumber);
}

public void playDeliverBill(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  deliverBill.setToLoopStart();
  deliverBill.start();
  tts.speak("" + tableNumber);
}

public void playClean(int tableNumber, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  clean.setToLoopStart();
  clean.start();
  tts.speak("" + tableNumber);
  customerNumber--;
}

public void playEmployeeAssistance(String initials, int prio) {
  prioGain.setGain(0.4 + (prio - 1) * 0.15);
  employeeAssistance.setToLoopStart();
  employeeAssistance.start();
  tts.speak(initials);
}

public void Busyness(int value) {
  float waveIntensity;
  
  for( int i = 0, n = 1; i < waveCount; i++, n++) {
    waveIntensity = (n==1) ? 1 : (customerNumber / 4) * (1.0 / n); 
    waveGain[i].setGain(waveIntensity);
  }
  if (masterWaveGain.getGain() == 0.0) {
    masterWaveGain.setGain(0.1);
  } else {
    masterWaveGain.setGain(0.0);
  }
}


void draw() {
  background(0);  //fills the canvas with black (0) each frame
  
  if (visual <= 0) {
    fill(255, 255, 255);
    ellipse(900, 95, 50,50);
  }
  
  int dt = millis() - time;
  time += dt;
  cd -= dt;
  visual -= dt;
  
  for (int i = 0; i < 6; i++) {
    stations[i].reduceCooldown(dt);
  }
  
  for (int i = 0; i < 6; i++) {
    if (!stations[i].events.isEmpty()){
      if (stations[i].getBusy() == false && stations[i].getEventAvailable() == false) {
        Notification n = stations[i].events.remove(0);
        n.timestamp += stations[i].delay;
        incEvents.add(n);
        stations[i].receiveEvent();
      }
    }
  }
  
  if (count < testData.size()) {
    if (incEvents.size() > 0) {
      curr = incEvents.get(0);
      for (Notification n: incEvents) {
        if (n.getTimestamp() < curr.getTimestamp()) {
          curr = n;
        }
      }
    }
  }
  
  if(curr != null && curr.getTimestamp() <= time && cd <= 0) {
    if (curr.getType() == 3) {
       // stations[4].triggerEvent(3000);
    } else if (curr.getType() == 9) {
       // stations[5].triggerEvent(3000);
    } else {
       // stations[curr.getTableNumber() - 1].triggerEvent(3000);
    }
    playSound(curr);
    cd = 3000;
    ongoingEvents.add(curr);
    incEvents.remove(curr);
    curr = null;
    count++;
    println(time);
    
  }
  
 /* 
  if (testData.getJSONObject(count).getInt("timestamp") >= time && cd <= 0) {
    playSound(testData.getJSONObject(count));
    cd = 6000;
    count++;
    println(count);
  }
  */

}
