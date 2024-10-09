`ifndef TYPES_SVH
`define TYPES_SVH

`include "config.svh"

// Q16.16 fixed point number
typedef logic signed [31:0] fix_t;

typedef logic[7:0] uint8_t;
typedef logic[15:0] uint16_t;
typedef logic[31:0] uint32_t;

typedef struct packed {
    fix_t x;
    fix_t y;
} vec_t;

typedef enum logic[1:0] {
    CELL_AIR,
    CELL_OSAKA,
    CELL_GRASS,
    CELL_HUOHUO
} cell_t;

typedef struct packed {
    logic is_vert;
    fix_t inv_dist;
    fix_t distance;
    vec_t pos;
    cell_t cell_type;
} ray_t;

typedef struct packed {
    logic is_vert;
    fix_t height;
    fix_t inv_height;
    vec_t ray_pos;
    fix_t ray_angle;
    cell_t cell_type;
} line_t;

typedef struct packed {
    uint8_t b;
    uint8_t g;
    uint8_t r;
} color_t;

typedef color_t texture_t [TEX_WIDTH-1:0];

`endif // `ifndef TYPES_SVH
