

module pixelArray
(
    input logic      VBN1,
    input logic      RAMP,
    input logic      RESET,
    input logic      ERASE,
    input logic      EXPOSE,
    input logic      READ0,
    input logic      READ1,
    input logic      READ2,
    input logic      READ3,
    inout logic[7:0] DATA
);

parameter real dv_pixel0 = 0.5; //Set the expected photodiode current (0-1)
parameter real dv_pixel1 = 0.5; //Set the expected photodiode current (0-1)
parameter real dv_pixel2 = 0.5; //Set the expected photodiode current (0-1)
parameter real dv_pixel3 = 0.5; //Set the expected photodiode current (0-1)

//Instanciate the pixel
PIXEL_SENSOR #(.dv_pixel(dv_pixel0)) p0(VBN1, RAMP, RESET, ERASE, READ0, DATA);
PIXEL_SENSOR #(.dv_pixel(dv_pixel1)) p1(VBN1, RAMP, RESET, ERASE, READ1, DATA);
PIXEL_SENSOR #(.dv_pixel(dv_pixel2)) p2(VBN1, RAMP, RESET, ERASE, READ2, DATA);
PIXEL_SENSOR #(.dv_pixel(dv_pixel3)) p3(VBN1, RAMP, RESET, ERASE, READ3, DATA);

endmodule