# Restaurant Wearable Audio Simulator
Audio simulator of futuristic compact wearable device for restaurant waiters created in Processing. Goal of the simulated device would be to allow restaurant servers to more easily be aware of their environment through audio cues of events surrounding them.

# Overview
When run, the simulator emulates a hypothetical audio environment that the device would provide in a restaurant as it gives audio cues that symbolize actual events in a restaurant that employees must be aware of. The audio the simulator sonifies depends on the input JSON file (66), and there are 3 data files given that have 3 different types of scenarios. Scenario one is dealing with a single table of customers, two has events from four tables of customers, and scenario three deals with three customers with the 3rd arriving after one customer has left.

Different sounds are given off by the simulator depending on the different data values in JSON files. The most crucial parameter is the type which is indicated by an integer, and the type of event leads to a different auditory icon for the sound.

Another parameter that modifies the sounds is priority which changes amplitude of the sounds. Some parameters are specific to each type of event. For the customer arrival sound, the sound indicator is filtered with a low pass filter if no reservation was made. For events that need servers to interact with customers seated at one of many tables, TTS is used to speak the exact table number, and there are 4 in the simulator. TTS is also used for the event of interacting with employees by referencing the employee’s exact initials. Another sound the simulator employs is the indication of the overall busyness of the restaurant which is determined by number of current customers / max number of customers. The busyness sound signal can be turned off and on by the button in the simulator, and it’s indicated by a soft programmatic wave player that gets closer towards a sawtooth wave away from a fundamental wave the busier the restaurant is.

To hear all of the sounds of each scenario, the user must “complete” events by interacting with the UI. Once a sound is played, a user can “complete” the event by clicking on the UI location that a server needs to be at to complete the event (go to entrance when customer arrives). Events must be completed to hear all of the sounds as some events are locked behind others and spaced out to try to emulate the realism of a restaurant (ex: must order food to be delivered bill).

# Running
After cloning the repository, the program can be opened in Processing.
https://processing.org/

With Processing downloaded, the Beads library must also be installed which can be done with the followinng instructions.
http://www.beadsproject.net/
