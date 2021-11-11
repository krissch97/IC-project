//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-10-11
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================


`timescale 1 ns / 1 ps


module pixelSensorFsm(
                       input logic        clk,
                       input  logic      reset,
                       output logic erase,
                       output logic expose,
                       output logic readStateOn,
                       output logic read0,
                       output logic read1,
                       output logic read2,
                       output logic read3,
                       output logic convert

                      );


   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 5;

   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;
   parameter READ0=0, READ1=1, READ2=2, READ3=3;


   logic               convert_stop;
   logic [2:0]         state,next_state;   //States
   logic [2:0]         readState,nextReadState;
   integer        counter;


   // Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           readStateOn <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           readStateOn <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           readStateOn <= 0;
           expose <= 0;
           convert <= 1;
        end
        READ: begin
           erase <= 0;
           readStateOn <= 1;
           expose <= 0;
           convert <= 0;
        case (readState)
           READ0: begin
              read0 <= 1;
              read1 <= 0;
              read2 <= 0;
              read3 <= 0;
           end
           READ1: begin
              read0 <= 0;
              read1 <= 1;
              read2 <= 0;
              read3 <= 0;
           end
           READ2: begin
              read0 <= 0;
              read1 <= 0;
              read2 <= 1;
              read3 <= 0;
           end
           READ3: begin
              read0 <= 0;
              read1 <= 0;
              read2 <= 0;
              read3 <= 1;
           end
        endcase
        end
        IDLE: begin
           erase <= 0;
           readStateOn <= 0;
              read0 <= 0;
              read1 <= 0;
              read2 <= 0;
              read3 <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)


   // Control the state transitions.
   //TODO: The counter should probably be an always_comb. Might be a good idea
   //to also reset the counter from the state machine, i.e provide the count
   //down value, and trigger on 0
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ;
                 state <= IDLE;
                 readState <= READ0;
              end
           end
           READ:
             if(counter == c_read) begin //READ1
                readState <= READ1;
             end
             else if(counter == 2*c_read) begin //READ2
                readState <= READ2;
             end
             else if(counter == 3*c_read) begin //READ3
                readState <= READ3;
             end
             else if(counter == 4*c_read) begin
                next_state <= ERASE;
                state <= IDLE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

endmodule // pixelSensorFSM
