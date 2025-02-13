class scoreboard;
  transaction tr; // Define a transaction object
  transaction trref; // Define a reference transaction object for comparison
  mailbox #(transaction) mbx; //mailbox to receive data from the driver
  mailbox #(transaction) mbxref; // mailbox to receive reference data from the generator
  event sconext; // Event to signal completion of scoreboard work
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx; // Initialize the mailbox for receiving data from the driver
    this.mbxref = mbxref; // Initialize the mailbox for receiving reference data from the generator
  endfunction
  
  task run();
    forever begin
      mbx.get(tr); // Get a transaction from the driver
      mbxref.get(trref); // Get a reference transaction from the generator
      tr.display("SCO"); // Display the driver's transaction information
      trref.display("REF"); // Display the reference transaction information
      if (tr.dout == trref.din)
        $display("[SCO] : DATA MATCHED"); // Compare data and display the result
      else if(tr.dout == 1'b0)
        $display("[SCO] : DATA Passed");
      else
        $display("[SCO] : DATA MISMATCHED");
      $display("-------------------------------------------------");
      ->sconext; // Signal completion of scoreboard work
    end
  endtask
  
endclass
