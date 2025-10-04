class wr_sequence1 extends uvm_sequence #(wr_seq_item);
  
  `uvm_object_utils(wr_sequence1)
  
  function new(string name = "wr_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = wr_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 1;})
  endtask
endclass

class wr_sequence2 extends uvm_sequence #(wr_seq_item);
  
  `uvm_object_utils(wr_sequence2)
  
  function new(string name = "wr_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = wr_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 0;})
  endtask
endclass

class wr_sequence3 extends uvm_sequence #(wr_seq_item);
  
  `uvm_object_utils(wr_sequence3)
  
  function new(string name = "wr_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = wr_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 1;})
  endtask
endclass

class wr_sequence4 extends uvm_sequence #(wr_seq_item);
  
  `uvm_object_utils(wr_sequence4)
  
  function new(string name = "wr_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = wr_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 0;})
  endtask
endclass
