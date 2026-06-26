`timescale 1ns / 1ps

// ============================================================
// Traffic Light Controller - TIMER Based
// States: S0 (Red/Green), S1 (Red/Yellow), S2 (Red/Red),
//         S3 (Green/Red), S4 (Yellow/Red), S5 (Red/Red)
// Lights[5:0] = {Light1_Red, Light1_Yellow, Light1_Green,
//                Light2_Red, Light2_Yellow, Light2_Green}
// ============================================================

module Traffic_Light_Time(
    input wire clk,
    input wire clr,
    output reg [5:0] lights
    );

    reg [2:0] state;
    reg [3:0] count;

    // State encoding
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010,
              S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    // Delay parameters (clock cycles)
    parameter SEC5 = 4'b1111,   // 15 cycles (~5 sec green phase)
              SEC1 = 4'b0011;   // 3  cycles (~1 sec yellow phase)

    // --------------------------------------------------------
    // Sequential Block: State Register + Counter
    // --------------------------------------------------------
    always @(posedge clk or posedge clr)
    begin
        if (clr == 1)
            begin
                state <= S0;
                count <= 0;
            end
        else
            case(state)
                // --- Road 1 Green phase (15 cycles) ---
                S0: if(count < SEC5)
                        begin
                            state <= S0;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S1;
                            count <= 0;
                        end

                // --- Road 1 Yellow phase (3 cycles) ---
                S1: if(count < SEC1)
                        begin
                            state <= S1;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S2;
                            count <= 0;
                        end

                // --- All Red / transition (3 cycles) ---
                S2: if(count < SEC1)
                        begin
                            state <= S2;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S3;
                            count <= 0;
                        end

                // --- Road 2 Green phase (15 cycles) ---
                S3: if(count < SEC5)
                        begin
                            state <= S3;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S4;
                            count <= 0;
                        end

                // --- Road 2 Yellow phase (3 cycles) ---
                S4: if(count < SEC1)
                        begin
                            state <= S4;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S5;
                            count <= 0;
                        end

                // --- All Red / transition (3 cycles) ---
                S5: if(count < SEC1)
                        begin
                            state <= S5;
                            count <= count + 1;
                        end
                    else
                        begin
                            state <= S0;
                            count <= 0;
                        end

                default:
                        begin
                            state <= S0;
                            count <= 0;
                        end
            endcase
    end

    // --------------------------------------------------------
    // Combinational Block: Output Logic
    // lights[5:0] = {R1, Y1, G1, R2, Y2, G2}
    // --------------------------------------------------------
    always @(*)
    begin
        case(state)
            S0: lights = 6'b100001; // Road1=Red,   Road2=Green
            S1: lights = 6'b100010; // Road1=Red,   Road2=Yellow
            S2: lights = 6'b100100; // Road1=Red,   Road2=Red
            S3: lights = 6'b001100; // Road1=Green, Road2=Red
            S4: lights = 6'b010100; // Road1=Yellow,Road2=Red
            S5: lights = 6'b100100; // Road1=Red,   Road2=Red
            default lights = 6'b100001;
        endcase
    end

endmodule
