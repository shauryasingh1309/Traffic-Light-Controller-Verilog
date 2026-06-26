`timescale 1ns / 1ps

// ============================================================
// Testbench for Traffic_Light_Sensor
// Matches the stimulus sequence shown in the project PDF
// ============================================================

module Traffic_Light_Sensor_tb;

    reg  clk;
    reg  clr;
    reg  SNS1;
    reg  SNS2;

    wire [1:0] TL1;
    wire [1:0] TL2;

    // Instantiate DUT
    Traffic_Light_Sensor uut (
        .clk (clk),
        .clr (clr),
        .SNS1(SNS1),
        .SNS2(SNS2),
        .TL1 (TL1),
        .TL2 (TL2)
    );

    // --------------------------------------------------------
    // Clock: period = 10 ns
    // --------------------------------------------------------
    always
    begin
        clk = 1;
        forever #(10/2) clk = ~clk;
    end

    // --------------------------------------------------------
    // Stimulus (matches PDF waveform)
    // --------------------------------------------------------
    initial
    begin
        // Reset
        clr  = 1;
        #13
        clr  = 0;

        // Sensor stimulus sequence (from PDF)
        SNS1 = 0; SNS2 = 0; #(10)
        SNS1 = 0; SNS2 = 1; #(40)   // SNS2 triggers Road2 service
        SNS1 = 0; SNS2 = 0; #(40)
        SNS1 = 1; SNS2 = 0; #(30)   // SNS1 triggers Road1 service
        SNS1 = 0; SNS2 = 0; #(20)
        SNS1 = 0; SNS2 = 1;         // SNS2 triggers again

        #50 $finish;
    end

    // --------------------------------------------------------
    // Dump waveforms
    // --------------------------------------------------------
    initial begin
        $dumpfile("traffic_sensor.vcd");
        $dumpvars(0, Traffic_Light_Sensor_tb);
    end

    // --------------------------------------------------------
    // Monitor
    // --------------------------------------------------------
    initial begin
        $monitor("Time=%0t | CLK=%b CLR=%b SNS1=%b SNS2=%b | TL1=%b TL2=%b",
                  $time, clk, clr, SNS1, SNS2, TL1, TL2);
    end

endmodule
