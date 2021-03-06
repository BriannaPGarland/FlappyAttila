# Flappy Attila

Recreating the popular mobile app *Flappy Bird* in VHDL but with a Stevens Institute of Technology twist

## Motivation

This is our final project for ***CPE 487 Digital System Design*** taught by Professor Kevin Lu

## Screenshots

**Demo:**

![gif of demo](https://user-images.githubusercontent.com/43273809/102029876-481d8580-3d7e-11eb-859a-6b5599f8a25c.gif)

**Closer look at Attila:**

![gif of Attila](https://user-images.githubusercontent.com/43273809/102033661-fe3a9c80-3d89-11eb-8654-2acf6f7ce174.gif)

## Features

 - Similar to lab 3 and lab 6 the "ball" or in our case Attila will be able to be controlled by the potentiometer to go up and down on the screen 
 - Randomly generated obstacles that Attila cannot run into or the game is over  
 - Score tracking system
 - Infinitely continuous background
 - Attila sprite

## Hardware Requirements

- Nexus A7 100T FPGA Board
- PMOD ADC1
- 5kΩ Petentiometer
- 600x800 resolution screen *(Disclaimer: game may not be playable outside of tested resolution)*

## How to use

*Controls:*

Use the potentiometer to control Attila as you navigate your way through the pipes

*Objective:*

Score points by succesffully getting through a pipe, the more pipes the higher score

*Winning:*

Score 15 times and restart to see how many you can win in a row!

## Credits

Huge thanks goes to our professor, Kevin Lu for teaching us, answering our questions, and providing the foundation for our code with [Lab 6: Video Game PONG](https://github.com/kevinwlu/dsd/tree/master/Nexys-A7/Lab-6). Also to Stevens Institute of Technology for providing the FPGA board for us to test and run our code.

**Our team members include:**

 - Brianna Garland
 - Edgar Castaneda-Vargas
 - Nathan Renner
 - Michael Shusta
 - Jack Hymowitz
 - Jayden Pereira
 - Dominic Zecchino
