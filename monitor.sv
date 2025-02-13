class monitor;
  transaction tr;
  mailbox #(transaction) mbx; // mailbox to send data to the scoreboard
  virtual dff_if vif; 
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // initialize the mailbox for sending data to the scoreboard
  endfunction
  
  task run();
    tr = new(); 
    forever begin
      repeat(2) @(posedge vif.clk); 
      tr.dout = vif.dout; // Capture DUT output
      mbx.put(tr); // Send the captured data to the scoreboard
      tr.display("MON"); 
    end
  endtask
  
endclass
