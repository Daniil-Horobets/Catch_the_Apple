# Catch The Apple: VGA Controller using FPGA with a small game implemented in VHDL

## Description
Project aimed at demonstrating the control of VGA output through FPGA. Developed 
on the Nexys 4 Board, which features a VGA output, the project's code is enough to be adapted to other FPGA 
boards, regardless of VGA output compatibility. To accommodate different boards replacement of the constraints file is needed. 
The resolution is set at 640x480 with a 25MHz pixel clock, achieving a refresh rate just under 60Hz. Image manipulation 
occurs at the pixel level, processing one pixel at a time, determined by the vertical counter (`VCnt`) and horizontal 
counter (`HCnt`). 
<br><br>

Repository contains full Vivado project, including constraints file, and all the necessary VHDL files.

## Game Idea
In "Catch The Apple," players are tasked with capturing falling apples in a straightforward gameplay format. Player 
start with three health points. Failing to catch a "good" apple results in the loss of one health point. Collecting 
four apples rewards the player with an additional health point. However, beware of the poisonous apples, which, upon 
collection, temporarily decrease the player's movement speed.

![](recourses/GameplayDemo.gif)

## Components

1. **clk_wiz_0 (Clock IP)**: Converts the 100 MHz input frequency of the board to a 25 MHz pixel clock, synchronizing 
all game modules.
2. **Fruit**: Generates apples at random intervals and locations. The game contains 3 instances that are recycled after 
being caught or missed.
3. **Poisonous_Fruit**: Represents an apple that decreases player speed for a short period when collected. The game 
contains 1 instance of this object.
4. **Player**: Visualized as a basket at the screen's bottom, maneuverable to the left or right via the BTNR and BTNL 
buttons.
5. **Collision**: Manages game logic based on the collision of different objects.
6. **Life_Counter**: Displays the player's remaining health points, updating the display in response to the game's 
collision outcome.
7. **Background**: Displays a static background picture of apple trees on a grassy terrain.
8. **Priority_MUX**: Determines the displayed pixel color by prioritizing input signals from game elements, forwarding 
the selected color to the VGA Controller.
9. **VGA_Controller**: Responsible for the rendering of game visuals on a monitor through the VGA port.

## Implementation Status

The game is fully functional, offering all intended gameplay features. There is room for further enhancements, such as 
visual improvements and adjustments to game difficulty progression. Additionally, code optimization could refine the 
overall quality.

## Operation of the Game

Gameplay initiates immediately upon programming the board. The CPU RESET button allows for game restarts. Players use 
the left (BTNL) and right (BTNR) buttons to control the basket. After a game over, a new session starts automatically, 
with no additional controls required.

## Reference
This project was developed as a part of ASIC lab at [Fridrich-Alexander University of Erlangen-Nuremberg (FAU)](https://www.fau.eu/) 
by myself and [alikarimie96](https://github.com/alikarimie96).
