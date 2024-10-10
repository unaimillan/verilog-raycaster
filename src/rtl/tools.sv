`ifndef TOOLS_SV
`define TOOLS_SV

`include "config.svh"
`include "types.svh"

function texture_t load_bmp (string path);
integer fd;
uint16_t signature, color_planes, bpp;
uint32_t data_offset, width, height;
texture_t texture;
begin
    fd = $fopen(path, "rb");
    $fread(signature, fd, 0);
    if (signature != 16'h424d) begin
        $display("image is not a bitmap");
        $finish;
    end
    $fseek(fd, 32'ha, 0);
    $fread(data_offset, fd);
    data_offset = {<<8{data_offset}}; // reverse endianness

    $fseek(fd, 32'h12, 0);
    $fread(width, fd);
    width = {<<8{width}};
    $fread(height, fd);
    height = {<<8{height}};
    if (width != `TEX_X || height != `TEX_Y) begin
        $display("image is must be %dx%d, found %dx%d.", `TEX_X, `TEX_Y,
        width, height);
        $finish;
    end

    $fread(color_planes, fd);
    color_planes = {<<8{color_planes}};
    if (color_planes != 1) begin
        $display("image must have 1 color plane, found %d.", 
                    color_planes);
    end

    $fread(bpp, fd);
    bpp = {<<8{bpp}};
    if (bpp != 24) begin
        $display("image encoding must be 24-bit/pixel, found %d.", bpp);
    end

    $fseek(fd, data_offset, 0);
    $fread(texture, fd);
    $fclose(fd);
    load_bmp = texture;
end
endfunction

`endif
