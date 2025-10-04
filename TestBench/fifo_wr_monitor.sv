class fifo_wr_monitor extends uvm_monitor;
  
  virtual fifo_interface.wr_mon vif;
  `uvm_component_utils(fifo_wr_monitor)
  
  uvm_analysis_port #(wr_seq_item) wr_mon_port;
  
  wr_seq_item req;
  
  function new(string name = "fifo_wr_monitor",uvm_component parent);
    super.new(name,parent);
    req = new;
    wr_mon_port = new("mon_port",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","password",vif))
      `uvm_fatal("WRITE_MONITOR","!!! NO Interface Found !!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      repeat(2)@(posedge vif.wr_mon_cb);
      req.winc = vif.wr_mon_cb.winc;
      req.wdata = vif.wr_mon_cb.wdata;
      req.wfull = vif.wr_mon_cb.wfull;
      wr_mon_port.write(req);
      `uvm_info("WRITE_MONITOR",$sformatf("capturing from write monitor & sending to scoreboard"),UVM_LOW);
      req.print();
    end
  endtask
endclass
