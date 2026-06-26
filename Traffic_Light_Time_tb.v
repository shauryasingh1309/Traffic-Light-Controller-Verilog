`timescale 1ns / 1ps

// ============================================================
// Testbench for Traffic_Light_Time
// ============================================================

module Traffic_Light_Time_tb;

    reg  clk;
    reg  clr;
    wire [5:0] lights;

    // Instantiate DUT
    Traffic_Light_Time uut (
        .clk(clk),
        .clr(clr),
        .lights(lights)
    );

    // --------------------------------------------------------
    // Clock & Reset
    // --------------------------------------------------------
    initial begin
        clk = 0;
        clr = 0;
        #100;
    end

    always
        #10 clk = ~clk;   // 20 ns period

    // --------------------------------------------------------
    // Dump waveforms (for GTKWave / ModelSim)
    // --------------------------------------------------------
    initial begin
        $dumpfile("traffic_time.vcd");
        $dumpvars(0, Traffic_Light_Time_tb);
        #2000 $finish;
    end

    // --------------------------------------------------------
    // Monitor output
    // --------------------------------------------------------
    initial begin
        $monitor("Time=%0t | CLK=%b CLR=%b | lights=%b", 
                  $time, clk, clr, lights);
    end

endmodule
