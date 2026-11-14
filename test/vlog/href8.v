module href8;
  sub u ();

  localparam P = u.f(1);   // Error
  wire [u.f(3):0] w;       // Error
endmodule // href8
