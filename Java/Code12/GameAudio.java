package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.io.File;
import java.io.IOException;
import javax.sound.sampled.*;
 

// Helper class for playing audio
public class GameAudio implements LineListener 
{
   // Instance data
   Game game;                    // back pointer to the Game
   double volume;                // sound volume from 0.0 to 1.0
   Clip audioClip;               // current clip being played or null if none


   // Construct the GameAudio helper with given back pointer to the Game
   GameAudio(Game game)
   {
      this.game = game;
      volume = 1.0;
      audioClip = null;
   }
    
   // Set the audio volume between 0.0 and 1.0
   void setVolume(double v)
   {
      volume = v;
   }
 
   // Play an audio file with the given filename        
   void play(String filename) 
   {
      // Do nothing if audio is already playing.
      // Mixing is not supported and stopping audio seems to work poorly.
      if (audioClip != null)
         return;
    
      // Look in the project folder first, then in the Code12/sounds subfolder.
      // Finally, check to see if the Code12 folder is in the parent folder.
      // If the file can't be found, warn the user just return.
      if (filename == null)
         return;
      File audioFile = new File(filename);
      if (!audioFile.isFile())
      {
         game.logError("Cannot find audio file", filename);
         return;
      }
      
      try 
      {         
         // Open the audio file and get the audioClip for it
         AudioInputStream audioStream = AudioSystem.getAudioInputStream(audioFile);
         DataLine.Info info = new DataLine.Info(Clip.class, audioStream.getFormat());
         audioClip = (Clip) AudioSystem.getLine(info);
         audioClip.addLineListener(this);
         audioClip.open(audioStream);             
         
         // Set the volume
         FloatControl gainControl = (FloatControl) audioClip.getControl(FloatControl.Type.MASTER_GAIN);
         gainControl.setValue((float) (Math.log(volume) / Math.log(10.0) * 20.0));

         // Play the clip
         audioClip.start();
      } 
      catch (UnsupportedAudioFileException ex) 
      {
         game.logError("Audio file not supported", filename);
      } 
      catch (LineUnavailableException ex) 
      {
         game.logError("Audio line unavailable for", filename);
      } 
      catch (IOException ex) 
      {
         game.logError("Cannot play audio file", filename);
      }
   }
        
   // LineListener method: Listen for the STOP event and close the clip when done.
   public void update(LineEvent event) 
   {         
      if (event.getType() == LineEvent.Type.STOP)
      {
         audioClip.close();
         audioClip = null;
      }
   }    
}
