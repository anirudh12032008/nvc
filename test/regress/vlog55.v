module vlog55;
  reg [7:0] r;
  wire [7:0] w;

  assign #(1:2:3) w = r;

  always @(w) $display("%0d w=%h", $time, w);

  initial begin
    #(10:20:30) r = 8'h5a;
    #(5:6:7) $display("%0d", $time);
    $finish;
  end
endmodule // vlog55
