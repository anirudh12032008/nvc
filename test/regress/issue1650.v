module issue1650_leaf;
  integer count = 0;

  function integer twice(input integer n);
    twice = n * 2;
  endfunction

  function automatic integer fact(input integer n);
    if (n <= 1)
      fact = 1;
    else
      fact = n * fact(n - 1);
  endfunction

  function one;
    one = 1;
  endfunction

  function integer dflt(input integer a, input integer b = 100);
    dflt = a + b;
  endfunction

  task split(input integer v, output integer hi, output integer lo);
    begin
      hi = v / 10;
      lo = v % 10;
    end
  endtask

  task bump(input integer by);
    count = count + by;
  endtask

  task slow_bump;
    begin
      #5;
      count = count + 10;
    end
  endtask
endmodule

module issue1650_pleaf #(parameter K = 0);
  function integer plus_k(input integer n);
    plus_k = n + K;
  endfunction
endmodule

module issue1650_mid;
  issue1650_leaf l1 ();
  issue1650_leaf l2 ();
endmodule

module issue1650;
  issue1650_mid m ();
  issue1650_leaf direct ();
  issue1650_pleaf #(3) p3 ();
  issue1650_pleaf #(5) p5 ();

  wire y = direct.one();                // Reproducer from the issue
  wire [31:0] w = direct.twice(21);

  reg [3:0] sel = 1;
  wire [31:0] dyn = direct.twice(sel);   // Re-evaluated when sel changes

  reg fail = 0;
  integer hi, lo;

  initial begin
    #1;
    if (dyn !== 2) fail = 1;
    sel = 4;
    #1;
    if (dyn !== 8) fail = 1;
    if (lt.three() !== 3) fail = 1;
    if (direct.dflt(1) !== 101) fail = 1;
    if (direct.dflt(1, 2) !== 3) fail = 1;
    direct.split(47, hi, lo);
    if (hi !== 4 || lo !== 7) fail = 1;
    if (y !== 1) fail = 1;
    if (w !== 42) fail = 1;
    if (m.l1.twice(4) !== 8) fail = 1;
    if (issue1650.direct.fact(5) !== 120) fail = 1;
    if (p3.plus_k(10) !== 13) fail = 1;
    if (p5.plus_k(10) !== 15) fail = 1;

    // Each instance has its own state
    m.l1.bump(3);
    m.l2.bump(5);
    direct.bump(7);
    if (m.l1.count !== 3) fail = 1;
    if (m.l2.count !== 5) fail = 1;
    if (direct.count !== 7) fail = 1;

    // Task that consumes time
    m.l2.slow_bump;
    if ($time !== 7) fail = 1;
    if (m.l2.count !== 15) fail = 1;

    if (fail)
      $display("FAILED");
    else
      $display("PASSED");
  end

  issue1650_later lt ();   // Declared after use
endmodule

module issue1650_later;
  function integer three;
    three = 3;
  endfunction
endmodule
