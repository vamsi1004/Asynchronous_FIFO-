class rd_sequence1 extends uvm_sequence #(rd_seq_item);
  
  `uvm_object_utils(rd_sequence1)
  
  function new(string name = "rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    req = rd_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{rinc == 1;})
  endtask
endclass

class rd_sequence2 extends uvm_sequence #(rd_seq_item);
  
  `uvm_object_utils(rd_sequence2)
  
  function new(string name = "rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    req = rd_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{rinc == 0;})
 
  endtask
endclass

class rd_sequence3 extends uvm_sequence #(rd_seq_item);
  
  `uvm_object_utils(rd_sequence3)
  
  function new(string name = "rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    req = rd_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{rinc == 0;})
  endtask
endclass

class rd_sequence4 extends uvm_sequence #(rd_seq_item);
  
  `uvm_object_utils(rd_sequence4)
  
  function new(string name = "rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    req = rd_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{rinc == 1;})
  endtask
endclass
