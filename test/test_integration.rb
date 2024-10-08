$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
path= File.expand_path(File.dirname(__FILE__) + '/../lib/bio-polymarker.rb')

tmp_verb = $VERBOSE
$VERBOSE=nil
#puts path
require path
require 'bio-samtools-wrapper'
require "test/unit"
$VERBOSE=tmp_verb


class TestInregration < Test::Unit::TestCase

  
  #Set up the paths
  def setup
    @data_path= File.expand_path(File.dirname(__FILE__)   + '/data/' )
    
    @ref="#{@data_path}/7B_amplicon_test_reference.fa"
    @amplicon = "#{@data_path}/7B_amplicon_test.fa"
    @genomes_count = 3
    @output_folder="#{@data_path}/test_out"
    @bin=File.expand_path(File.dirname(__FILE__) + '/../bin')
    @marker = "#{@data_path}/7B_marker_test.txt"
    FileUtils.rm_r(@output_folder, force: true) if Dir.exist? @output_folder

    cmd = "makeblastdb -in #{@ref} -dbtype nucl "
    #status, stdout, stderr = 
    systemu cmd
    # @ref=data_path + '/S22380157.fa'
    # @a=data_path + "/LIB1721.bam"
    # @b=data_path + "/LIB1722.bam"
    # @f2_a=data_path + "/LIB1716.bam"
    # @f2_b=data_path + "/LIB1719.bam"
    
    # @bfr_path=data_path + "/bfr_out_test.csv"
    # @fasta_db = Bio::DB::Fasta::FastaFile.new({:fasta=>@ref})
    # @fasta_db.load_fai_entries
    # @bam_a =  Bio::DB::Sam.new({:fasta=>@ref, :bam=>@a})
    # @bam_b =  Bio::DB::Sam.new({:fasta=>@ref, :bam=>@b})
    # @bam_f2_a =  Bio::DB::Sam.new({:fasta=>@ref, :bam=>@f2_a})
    # @bam_f2_b =  Bio::DB::Sam.new({:fasta=>@ref, :bam=>@f2_b})
   # puts "SETUP"

  end
  
  def teardown
    FileUtils.rm_r(@output_folder, force: true) if Dir.exist? @output_folder
    Dir.glob("#{@ref}.n*").each do |file| 
      #puts file 
      File.delete(file)
    end
  end
  
  def test_amplicon_primers
    cmd = "ruby #{@bin}/polymarker_capillary.rb --reference #{@ref} --sequences #{@amplicon}  --genomes_count #{@genomes_count}  --output #{@output_folder} --database #{@ref}"
    status, stdout, stderr = systemu cmd
    assert_equal(status.exitstatus, 0, "Failed running '#{cmd}'\nSTDOUT:\n#{stdout}\nSTDERR\n#{stderr}")
   
  end

  def test_deletion_primers
    cmd = "ruby #{@bin}/polymarker_deletions.rb --reference #{@ref} --sequences #{@amplicon}  --genomes_count #{@genomes_count}  --output #{@output_folder} --database #{@ref}"
    status, stdout, stderr = systemu cmd
     assert_equal(status.exitstatus, 0, "Failed running '#{cmd}'\nSTDOUT:\n#{stdout}\nSTDERR\n#{stderr}")
  end

  def test_polymerker
    cmd = "ruby ./bin/polymarker.rb -m #{@marker} -c #{@ref} --extract_found_contigs  -A blast -a nrgene --output #{@output_folder}"
    status, stdout, stderr = systemu cmd
     assert_equal(status.exitstatus, 0, "Failed running '#{cmd}'\nSTDOUT:\n#{stdout}\nSTDERR\n#{stderr}")
  end

end