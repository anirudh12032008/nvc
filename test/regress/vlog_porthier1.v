module leaf;
  reg [3:0] st = 5;
endmodule

module mid;
  leaf l();
endmodule

module inner(input [3:0] a, output [3:0] b);
  assign b = a;
endmodule

module vlog_porthier1;
  mid m();
  leaf l();
  wire [3:0] w1, w2, w3;

  // Hierarchical references in port connections
  inner p1 (m.l.st, w1);
  inner p2 (l.st, w2);
  inner p3 (l.st + 4'd1, w3);

  initial begin
    #1;
    if (w1 === 4'd5 && w2 === 4'd5 && w3 === 4'd6)
      $display("PASSED");
    else
      $display("FAILED");
  end
endmodule
