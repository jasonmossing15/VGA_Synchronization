# VGA Synchronization

## Introduction

The purpose of this lab is to create code that will synchronize two signals on a FPGA in order to create a VGA controller. The two signals that are needed are h_sync and v_sync. The h signal is for the horizontal pixels and the v signal is for the vertical lines on the screen. The main problem that needed to be acomplished for this lab was creating these two signals and making sure their timing matched, because if they didn't then the program would not work.

## Implementation

--Coming soon

## Test/Debug

The testing method I used was the using assert statements and checking the waveform of the signal output. The assert statements were useful in the begining, but as more time and tests went on the waveform was more useful. Another technique used was to change the row/column output to constantly show the count in order to see what changes where happening when. The waveforms were essential because yoou can count the amount of time paasses in each state, which affirms the timing of each signal.  

I ran into a couple of main issues. The first being an additional count in my v_sync_gen and the second being I was running into some glitches due to a quick state change. The third issue was using the correct clock. 

- The first issue was fixed by adding an if statement checking to see if h_completed = '1'. This caused the last value of the count to "stall" instead of switching after the next clock cycle. It made the next state logic dependent on h_completed. 

 - The second issue was fixed by the use of a look-ahead output buffer. The output buffer caused all switching of states and outputs to settle before they showed change. This is essential for making sure your signals are stable and happen when expected.

 - The third issue was fixed by changing clk to pixel_clk in my top level. This change changed the clock speed from 100MHz to 25MHz which makes a big deal when dealing with sending signals through an output.

## Conclusion

Overall I learned that timing is an absolutly crutial part in desiging digital systems. I learned that even one clock cycle difference can give you a big problem. I also learned that out buffers are key in the use of moore machines because you decrease your risk of a glitch exponentially. If I were to change this lab I would add another lab prior in order to demonstrate basic VHDL skills without such of an emphasis on timing. The extreme timing requirement made this lab a lot tougher.
