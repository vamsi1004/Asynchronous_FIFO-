 `include "uvm_macros.svh"
  import uvm_pkg::*;

class rd_seq_item extends uvm_sequence_item;
  
  rand bit rinc;
  bit [7:0] rdata;
  bit rempty;
  
  function new(string name = "rd_seq_item");
    super.new(name);
  endfunction 
  
  `uvm_object_utils_begin(rd_seq_item)
  `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_field_int(rinc, UVM_ALL_ON)
  `uvm_field_int(rempty,UVM_ALL_ON)
  `uvm_object_utils_end
endclass
