class virtual_sequence extends uvm_sequence;
  
  wr_sequence1 wr_seq1;
  wr_sequence2 wr_seq2;
  wr_sequence3 wr_seq3;
  wr_sequence4 wr_seq4;
  
  rd_sequence1 rd_seq1;
  rd_sequence2 rd_seq2;
  rd_sequence3 rd_seq3;
  rd_sequence4 rd_seq4;
  
  fifo_wr_sequencer wr_seqr;
  fifo_rd_sequencer rd_seqr;
  
  `uvm_object_utils(virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)
  
  function new(string name = "virtual_seq");
    super.new(name);
  endfunction 
  
  virtual task body();
    wr_seq1 = wr_sequence1::type_id::create("wr_Seq1");
    wr_seq2 = wr_sequence2::type_id::create("wr_Seq2");
    wr_seq3 = wr_sequence3::type_id::create("wr_Seq3");
    wr_seq4 = wr_sequence4::type_id::create("wr_Seq4");
    
    rd_seq1 = rd_sequence1::type_id::create("rd_seq1");
    rd_seq2 = rd_sequence2::type_id::create("rd_seq2");
    rd_seq3 = rd_sequence3::type_id::create("rd_seq3");
    rd_seq4 = rd_sequence4::type_id::create("rd_seq4");
    
    fork
      begin
        wr_seq1.start(p_sequencer.wr_seqr);
        #100;
      end
      begin
        rd_seq1.start(p_sequencer.rd_seqr);
        #100;
      end
    join
    fork
        wr_seq2.start(p_sequencer.wr_seqr);
        rd_seq2.start(p_sequencer.rd_seqr);
    join
    fork
      begin
        wr_seq3.start(p_sequencer.wr_seqr);
        #100;
      end
        rd_seq3.start(p_sequencer.rd_seqr);
    join
    fork   
        wr_seq4.start(p_sequencer.wr_seqr);
     begin
        rd_seq4.start(p_sequencer.rd_seqr);
        #100;
     end
   join
  endtask
  
endclass
