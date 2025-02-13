class generator;
  transaction tr;  // Define a transaction object
  mailbox #(transaction) mbx;      // Create a mailbox to send data to the driver
  mailbox #(transaction) mbxref;   // Create a mailbox to send data to the scoreboard for comparison/golden data
  event sconext; // Event to sense the completion of scoreboard work
  event done;    // Event to trigger when the requested number of stimuli is applied
  int count;     // Stimulus count
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;  // Initialize the mailbox for the driver
    this.mbxref = mbxref; // Initialize the mailbox for the scoreboard
    tr = new(); // Create a new transaction object
  endfunction
  
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] : RANDOMIZATION FAILED");
      mbx.put(tr.copy); // Put a copy of the transaction into the driver mailbox
      mbxref.put(tr.copy); // Put a copy of the transaction into the scoreboard mailbox
      tr.display("GEN"); // Display transaction information
      @(sconext); // Wait for the scoreboard's completion signal
    end
    ->done; // Trigger "done" event when all stimuli are applied
  endtask
  
endclass
