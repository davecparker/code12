package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.io.File;
import java.io.IOException;
import javax.sound.sampled.*;
import java.util.*;
 

// Helper class for playing audio
public class GameAudio 
{
   // Instance data
   Game game;                    // back pointer to the Game
   double volume;                // sound volume from 0.0 to 1.0
   HashMap<String, Clip> clips;  // loaded and cached audio clips 


   // Construct the GameAudio helper with given back pointer to the Game
   GameAudio(Game game)
   {
      this.game = game;
      volume = 1.0;
      clips = new HashMap<String, Clip>();
   }
    
   // Set the audio volume between 0.0 and 1.0
   void setVolume(double v)
   {
      volume = v;
   }
 
   // Preload and cache an audio file with the given filename
   boolean load(String filename)
   {
      return (getClip(filename) != null);
   }
   
   // Play an audio file with the given filename        
   void play(String filename) 
   {
      // Get the clip
      Clip clip = getClip(filename);
      if (clip == null)
         return;
      
      // Stop and reset the clip if it is already playing
      if (clip.isRunning())
      {
         clip.stop();
         clip.flush();
      }
      clip.setFramePosition(0);

      // Set the volume
      FloatControl gainControl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);
      gainControl.setValue((float) (Math.log(volume) / Math.log(10.0) * 20.0));

      // Start the clip
      clip.start();
   }

   // Return the audio clip for the given sound filename or null if failure.
   private Clip getClip(String filename)
   {
      // Is this clip already loaded?
      Clip clip = clips.get(filename);
      if (clip != null)
      {
         return clip;
      }
      
      // Try to find the file
      if (filename == null)
         return null;
      File file = new File(filename);
      if (!file.isFile())
      {
         game.logError("Cannot find audio file", filename);
         return null;
      }
      try 
      {
         // Get a Clip and prepare it
         AudioInputStream stream = AudioSystem.getAudioInputStream(file);
         clip = AudioSystem.getClip();
         clip.open(stream);             
         clips.put(filename, clip);   // cache it
      } 
      catch (LineUnavailableException ex) 
      {
         game.logError("Audio line unavailable for", filename);
      } 
      catch (UnsupportedAudioFileException ex) 
      {
         game.logError("Audio file not supported", filename);
      } 
      catch (IOException ex) 
      {
         game.logError("Cannot play audio file", filename);
      }
      return clip;
   }
}
