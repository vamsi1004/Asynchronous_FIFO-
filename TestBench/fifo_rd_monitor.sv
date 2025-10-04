class fifo_rd_monitor extends uvm_monitor;
  
  virtual fifo_interface.rd_mon vif;
  `uvm_component_utils(fifo_rd_monitor)
  
  uvm_analysis_port #(rd_seq_item) rd_mon_port;
  
  rd_seq_item req;
  
  function new(string name = "fifo_rd_monitor",uvm_component parent);
    super.new(name,parent);
    req = new;
    rd_mon_port = new("mon_port1",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","password",vif))
      `uvm_fatal("WRITE_MONITOR","!!! NO Interface Found !!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      repeat(2)@(posedge vif.rd_mon_cb);
      req.rinc = vif.rd_mon_cb.rinc;
      req.rdata = vif.rd_mon_cb.rdata;
      req.rempty = vif.rd_mon_cb.rempty;
      rd_mon_port.write(req);
      `uvm_info("READ_MONITOR",$sformatf("capturing from read monitor & sending to scoreboard"),UVM_LOW);
      req.print();
    end
  endtask
endclass
