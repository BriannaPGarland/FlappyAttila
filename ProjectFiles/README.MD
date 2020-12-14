# Project Files for Flappy Attila FPGA Game 

### Source Files 
  * *bird_n_buildings.vhd* : This file contains the game logic and also controls what shows up on the screen 
  * *flappy.vhd* : The file where every component is being called for the game. 
  * *leddec.vhd* : This file allows for us to be able to use the FPGA board to display the score. 
  * *adc_if.vhd* : This file checks for rising edge and other similar functions 
  * *clk_wiz_0.vhd* : This file allows for the display to a VGA monitor, and is how we are able to use the monitor to display our game
  * *clk_wiz_0_clk_wiz.vhd : * This file also contributes to the functionality of using a display 
  * *vga_sync* : This file is where we were able to control the dimensions of the game (i.e. the height and width on the monitor). It is also where the refresh rate                  is controlled
  
### Constraint Files
  * *flappy.xdc* : This file is the constraint file where the commands control functions of the board it's self. 


   
