# ECE 385 final project: Breakout
**by Marek Wasilczuk and Amadeus Justinn Haryanto**

This is a version of the Atari game [Breakout](https://en.wikipedia.org/wiki/Breakout_(video_game)) built using SystemVerilog and C code. It is to be run on Altera Quartus with a MAX10 FPGA connected to a VGA screen.
## Instructions for starting the game
### Connecting devices and peripherals
1. Connect a MAX10 FPGA to your machine as well as to a monitor via the VGA port.
2. Connect a USB I/O module onto the FPGA, then connect a USB keyboard to it.
### Running the project
1. Clone this repository by running `git clone https://github.com/amadeusjustinn/Breakout.git`, or download the code as a .ZIP file (click Code > Download ZIP) and decompress it.
2. Open Altera Quartus, click Open Project, and open `ece385lab6.qpf` found in the project folder. The project has already been compiled since the last push (To recompile after modifying the code yourself, click the green play button on the toolbar, or click Processing > Start Compilation, or click `Ctrl`+`L`).
3. Go to Tools > Programmer; you should see the MAX10 device listed there. Click the device and click Start. Once the progress bar fills up completely, the start screen should appear on your monitor.
4. Go to Tools > NIOS II Software Build Tools for Eclipse. Select the `software` folder as the workspace. Two folders, `usb_kb` and `usb_kb_bsp`, should be visible in the Project Explorer on the right (If not, click File > Import and import those two folders from the `software` folder).
5. Right-click `usb_kb_bsp` and click NIOS II > Generate BSP.
6. Click Project > Build All or click `Ctrl`+`B`.
7. Click Run > Run Configurations..., click the Target Connections tab and click Refresh Connections. The MAX10 device should be listed under Processors.
8. Click Run. The controls mentioned below should be working.
## The game
The instruction "Press any key" is not completely true; clicking the space bar, `A` or `D` will not start the game to prevent changes to the unstarted game (ball launches or bar moves before game starts). After pressing any other key, the game should appear on the monitor.

_Controls: Press the space bar to launch the ball from the bar. Use `A` and `D` to move the bar left and right respectively._

The hexadecimal score, which is displayed on the bottom-left corner of the screen, increases by 1 every time a block is destroyed. The number of lives, which is represented by initially 3 yellow blocks on the bottom-right corner, decreases by 1 every time the ball travels downwards past the bar. Once there are no more lives, the entire game (the blocks, the score, the number of lives etc.) resets.
