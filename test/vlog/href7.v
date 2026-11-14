module sub7;
  integer v;
  function integer f(input integer a, input integer b);
    f = a + b;
  endfunction
  task t(input integer a);
    v = a;
  endtask
endmodule // sub7

module href7;
  sub7 u ();

  initial begin
    $display(u.f(1));           // Error
    $display(u.f(1, 2, 3));     // Error
    u.t;                        // Error
    u.t(1, 2);                  // Error
    u.f(1, 2);                  // Error
    $display(u.t(1));           // Error
    $display(u.v(1));           // Error
    $display(u.nothere(1));     // Error
    $display(nonesuch.f(1, 2)); // Error
  end
endmodule // href7
