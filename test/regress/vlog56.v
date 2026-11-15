module vlog56;
  function signed [31:0] neg32(input integer x);
    neg32 = -x;
  endfunction

  function integer negi(input integer x);
    negi = -x;
  endfunction

  function signed [7:0] neg8(input integer x);
    neg8 = -x;
  endfunction

  function [7:0] uneg8(input integer x);
    uneg8 = -x;
  endfunction

  function f1;
    input a;
    f1 = 1'b1;
  endfunction

  function signed fs;
    input a;
    fs = 1'b1;
  endfunction

  reg failed = 0;
  reg signed [63:0] sw;
  reg [63:0] wide;
  reg signed [63:0] swide;
  integer i;

  initial begin
    // Comparison and display use the signed return type
    if (!(neg32(2) < 0)) failed = 1;
    if (!(negi(2) < 0)) failed = 1;
    if (!(neg8(2) < 0)) failed = 1;
    if (uneg8(2) < 0) failed = 1;
    $display("%0d %0d %0d %0d", neg32(2), negi(2), neg8(2), uneg8(2));

    // Sign extension into wider targets
    wide = neg32(2);
    if (wide !== 64'hffffffff_fffffffe) failed = 1;
    swide = neg8(2);
    if (swide !== -64'sd2) failed = 1;
    wide = uneg8(2);
    if (wide !== 64'h00000000_000000fe) failed = 1;

    // Arithmetic shift preserves the sign
    i = neg32(8) >>> 1;
    if (i !== -4) failed = 1;
    i = neg8(8) >>> 1;
    if (i !== -4) failed = 1;

    // Mixed signed and unsigned operands make the result unsigned
    if ((neg32(2) < 32'd1) !== 1'b0) failed = 1;
    if ((neg32(2) < 32'sd1) !== 1'b1) failed = 1;

    // Implicit 1-bit return is unsigned
    if (f1(0) < 0) failed = 1;
    wide = f1(0);
    if (wide !== 64'd1) failed = 1;

    // Signed 1-bit return sign-extends
    sw = fs(0);
    if (sw !== -64'sd1) failed = 1;

    // Signed calls inside larger expressions
    sw = neg8(2) + neg8(1);
    if (sw !== -64'sd3) failed = 1;
    sw = neg32(neg32(2));
    if (sw !== 64'sd2) failed = 1;
    $display("%0d %0d %0d %0d", f1(0), fs(0), neg8(2) + neg8(1), neg32(neg32(2)));

    if (failed)
      $display("FAILED");
    else
      $display("PASSED");
  end
endmodule
