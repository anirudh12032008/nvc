module vlog53;
  parameter P = 1:2:3;
  reg [7:0] r;
  wire [7:0] w;
  integer n = -(4:5:6);

  assign #(1:2:3) w = r;

  always @(w) $display("%0d w=%h", $time, w);

  initial begin
    #(10:20:30) r = 8'h5a;
    #(5:6:7) $display("%0d", $time);
    #P $display("%0d", $time);
    #(1:(2:3:4):5) $display("%0d", $time);
    $display("%0d", n);
    $finish;
  end
endmodule // vlog53
