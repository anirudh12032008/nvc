module leaf #(parameter P = 5);
  reg [3:0] st = P;
endmodule

module mid;
  leaf l();
endmodule

module inner(input [3:0] a, output [3:0] b);
  assign b = a;
endmodule

// Has its own instance named l which must not capture the reference
module shadow(input [3:0] a, output [3:0] b);
  leaf #(9) l();
  assign b = a;
endmodule

module vlog_porthier1;
  mid m();
  leaf l();
  wire [3:0] w1, w2, w3, w4;

  // Hierarchical references in port connections
  inner p1 (m.l.st, w1);
  inner p2 (l.st, w2);
  inner p3 (l.st + 4'd1, w3);
  shadow p4 (l.st, w4);

  initial begin
    #1;
    if (w1 === 4'd5 && w2 === 4'd5 && w3 === 4'd6 && w4 === 4'd5
        && p4.l.st === 4'd9)
      $display("PASSED");
    else
      $display("FAILED");
  end
endmodule
