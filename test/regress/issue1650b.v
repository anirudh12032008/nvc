module issue1650b_leaf;
  integer x = 0;

  function integer inc(input integer n);
    inc = n + 1;
  endfunction

  task set(input integer v);
    x = v;
  endtask
endmodule

module issue1650b_child;
  reg ok = 0;

  initial begin
    #2;
    // Absolute path from the root
    if (issue1650b.u.inc(9) === 10) ok = 1;
    issue1650b.u.set(42);
  end
endmodule

module issue1650b;
  issue1650b_leaf u ();
  issue1650b_child c ();

  if (1) begin: g
    issue1650b_leaf v ();
  end

  reg fail = 0;

  initial begin
    #3;
    if (c.ok !== 1) fail = 1;
    if (u.x !== 42) fail = 1;
    g.v.set(6);
    if (g.v.x !== 6) fail = 1;
    if (g.v.inc(1) !== 2) fail = 1;
    if (fail)
      $display("FAILED");
    else
      $display("PASSED");
  end
endmodule
