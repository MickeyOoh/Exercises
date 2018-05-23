defmodule GrepTest do
  use ExUnit.Case
  doctest Grep

  ExUnit.configure(exclude: :pending, trace: true)
  @test_file1 "iliad.txt"
  @test_file2 "iliad.txt"
  @test_file3 "iliad.txt"
  setup context do
    if context[:files] do
      File.write!(@test_file1, """
      Achilles sing, O Goddess! Peleus' son;
      His wrath pernicious, who ten thousand woes
      Caused to Achaia's host, sent many a soul
      Illustrious into Ades premature,
      And Heroes gave (so stood the will of Jove)
      To dogs and to all ravening fowls a prey,
      When fierce dispute had separated once
      The noble Chief Achilles from the son
      Of Atreus, Agamemnon, King of men.
      """)

      File.write!("midsummer-night.txt", """
      I do entreat your grace to pardon me.
      I know not by what power I am made bold,
      Nor how it may concern my modesty,
      In such a presence here to plead my thoughts;
      But I beseech your grace that I may know
      The worst that may befall me in this case,
      If I refuse to wed Demetrius.
      """)

      File.write!("paradise-lost.txt", """
      Of Mans First Disobedience, and the Fruit
      Of that Forbidden Tree, whose mortal tast
      Brought Death into the World, and all our woe,
      With loss of Eden, till one greater Man
      Restore us, and regain the blissful Seat,
      Sing Heav'nly Muse, that on the secret top
      Of Oreb, or of Sinai, didst inspire
      That Shepherd, who first taught the chosen Seed
      """)

      on_exit(fn ->
        File.rm!("iliad.txt")
        File.rm!("midsummer-night.txt")
        File.rm!("paradise-lost.txt")
      end)
    end
  end

  @moduletag :files
  import Grep.Search
  describe "parse args checking" do 
    test "arg help check" do
      assert parse_args(["-h"]) == :help
    end
    @testfile "mix.exs"
    @testlines "test1 def checking"

    test "arg line_num" do
      {code, fncregex,files,fncout} = 
        parse_args(["def", @testfile])
      assert code == :lines
      assert fncregex.(@testlines) == true
      assert files == [@testfile]
      #assert fncout.([@testfile, "9", @testlines])
    end
  end
  describe "grep command checking" do
    test "test test" do  
      prnout = System.cmd("./grep", ["def", "mix.exs"])
      #IO.puts prnout
    end
  end
end
