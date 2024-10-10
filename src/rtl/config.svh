`ifndef CONFIG_SVH
`define CONFIG_SVH

`default_nettype none
`timescale 1ns / 1ps

`define LEVEL       "levels/8x8/multi.mem"
`define MAP_X       8  
`define MAP_Y       8 
`define MAP_SCALE_X 64.0
`define MAP_SCALE_Y 64.0
`define MAP_SCALE_Z 64.0
`define MAP_WRAP

`define TEX_X 256
`define TEX_Y 256
`define TEX_WIDTH (`TEX_X*`TEX_Y)

`define PLAYER_SPEED      2.0
`define PLAYER_TURN_SPEED 0.05 // radians
`define PLAYER_INIT_X     (MAP_SCALE_X * MAP_X / 2)
`define PLAYER_INIT_Y     (MAP_SCALE_Y * MAP_Y / 2)
`define PLAYER_INIT_ANGLE 0.0

`define FOV (PI / 3) // 60deg

`define TRIG_SAMPLES 256

`define MAP_OVERLAY
`define OVERLAY_SCALE_X     0.5
`define OVERLAY_SCALE_Y     0.5
`define OVERLAY_OFFSET_X    0.0
`define OVERLAY_OFFSET_Y    0.0
`define OVERLAY_PLAYER_SIZE 5.0

`endif // ifndef CONFIG_SVH
