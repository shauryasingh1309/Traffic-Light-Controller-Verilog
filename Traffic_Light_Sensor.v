`timescale 1ns / 1ps

// ============================================================
// Traffic Light Controller - SENSOR Based
// SNS1 = sensor on Road 1 (detects waiting vehicles)
// SNS2 = sensor on Road 2 (detects waiting vehicles)
//
// States:
//   S0 (2'b00) -> Road1 Green , Road2 Red
//   S1 (2'b01) -> Road1 Yellow, Road2 Red
//   S2 (2'b10) -> Road1 Red,    Road2 Green
//   S3 (2'b11) -> Road1 Red,    Road2 Yellow
//
// TL1[1:0], TL2[1:0]: 2'b00=green, 2'b01=yellow, 2'b10=red
// ============================================================

module Traffic_Light_Sensor(
    input  clk,
    input  clr,
    input  SNS1,         // Vehicle sensor – Road 1
    input  SNS2,         // Vehicle sensor – Road 2
    output reg [1:0] TL1,
    output reg [1:0] TL2
    );

    reg [1:0] state, nextstate;

    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01,
              S2 = 2'b10, S3 = 2'b11;

    // Output encoding
    parameter green  = 2'b00,
              yellow = 2'b01,
              red    = 2'b10;

    // --------------------------------------------------------
    // Sequential Block: State Register
    // --------------------------------------------------------
    always @(posedge clk, posedge clr)
    begin
        if(clr) state <= S0;
        else     state <= nextstate;
    end

    // --------------------------------------------------------
    // Combinational Block: Next-State Logic
    // Transitions driven by sensors
    // --------------------------------------------------------
    always @(*)
    begin
        case(state)
            // If Road2 has vehicles waiting → go to yellow; else hold
            S0: if(SNS2) nextstate = S1;
                else      nextstate = S0;

            // After Road1 yellow → Road2 gets green
            S1:           nextstate = S2;

            // If Road1 has vehicles waiting → go to yellow; else hold
            S2: if(SNS1) nextstate = S3;
                else      nextstate = S2;

            // After Road2 yellow → Road1 gets green
            S3:           nextstate = S0;

            default:      nextstate = S0;
        endcase
    end

    // --------------------------------------------------------
    // Combinational Block: Output Logic
    // --------------------------------------------------------
    always @(*)
    begin
        if(state == S0)
            begin
                TL1 = green;
                TL2 = red;
            end
        else if(state == S1)
            begin
                TL1 = yellow;
                TL2 = red;
            end
        else if(state == S2)
            begin
                TL1 = red;
                TL2 = green;
            end
        else
            begin
                TL1 = red;
                TL2 = yellow;
            end
    end

endmodule
