require "tic_tac_toe"

module TicTacToe
  describe Game do 
    let(:game)   { Game.new }
    before(:each) do
      game.array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      game.positions = []
    end

    context "#start" do
      before(:each) { game.stub(:sleep) }

      it "sends a welcome message" do
        game.should_receive(:puts).exactly(3).times
        game.start
      end

      it "should sleep twice" do
        game.should_receive(:sleep).with(1).twice
        game.start
      end 

      it "array should have 9 items" do
        game.start
        game.array.should have_exactly(9).items
      end
    end 

    context "#first_move" do
      it "user takes first move" do
        game.stub_chain(:gets, :chomp).and_return("heads")
        game.stub(:rand).and_return(1)
        game.should_receive(:puts).and_return("You won!Please,start.")
        game.should_receive(:user_moves)
        game.first_move
      end

      it "system takes first move" do
        game.stub_chain(:gets, :chomp).and_return("heads")
        game.stub(:rand).and_return(0)
        game.should_receive(:puts).and_return("Ha-ha!You've lost! I'm starting.")
        game.should_receive(:system_moves)
        game.first_move
      end

      it "wrong input" do
        game.stub_chain(:gets, :chomp).and_return("dhfjdk","tails")
        game.stub(:rand).and_return(1)
        game.should_receive(:puts).and_return("I said, 'heads' or 'tails'!")
        game.should_receive(:system_moves)
        game.first_move
      end
    end

    context "#user_moves" do 
      it "wrong number input" do
        game.stub_chain(:gets, :chomp, :to_i).and_return(5465,1)
        game.should_receive(:puts).and_return("Error!Number should be in 1..9")
        #game.array = [1,2,3,4,5,6,7,8,9]
        game.user_moves
      end

      it "array should include '0'" do
        game.stub_chain(:gets, :chomp, :to_i).and_return(1)
        game.user_moves
        game.array.should include("0")
      end

      it "positions should not be empty" do
        game.stub_chain(:gets, :chomp, :to_i).and_return(1)
        game.user_moves
        game.positions.should_not be_empty
      end

    end

    context "#system_moves" do
      it "if positions empty" do
        game.positions = []
        game.stub(:rand).and_return(0)
        game.should_receive(:rand).with(9)
        game.system_moves
        game.array.should include("X")
      end

      it "should receive smart_system 8 times" do
        game.positions = [1,3,4]
        game.should_receive(:smart_system).exactly(8).times
        game.system_moves
      end

      it "random in free cells" do
        game.positions = [1,8]
        game.stub(:rand).and_return(0)
        game.should_receive(:smart_system).exactly(8).times.and_return(false)
        game.system_moves
        game.array[0].should eql("X")
      end
    end

    context "#smart_system" do
      it "third X in the end" do
        game.array = ['0','0',3,4,5,6,7,8,9]
        game.smart_system(0,1,2).should be true
      end

      it "third X between" do
        game.array = ['0',2,'0',4,5,6,7,8,9]
        game.smart_system(0,1,2).should be true
      end

      it "third X at the beginning" do
        game.array = [1,'0','0',4,5,6,7,8,9]
        game.smart_system(0,1,2).should be true
      end

      it "no combinations" do
        game.array = [1,'0',3,4,5,6,7,8,9]
        game.smart_system(0,1,2).should be false
      end
    end

    context "#two_in_row?" do
      it "two 'X' in a row" do
        game.array[0] = 'X'
        game.array[1] = 'X'
        game.two_in_row?(0,1).should be true
      end

      it "two '0' in a row" do
        game.array[0] = '0'
        game.array[1] = '0'
        game.two_in_row?(0,1).should be true
      end

      it "different values in a row" do
        game.array[0] = 'X'
        game.array[1] = '0'
        game.two_in_row?(0,1).should be false
      end
    end

    context "#three_in_row?" do
      context "'X'" do
        before(:each) do
          game.array[0] = 'X'
          game.array[1] = 'X'
          game.array[2] = 'X'
        end

        it "three 'X' in a row" do
          game.three_in_row?(0,1,2).should be true
        end

        it "system_winner is true" do
          game.three_in_row?(0,1,2)
          game.system_winner.should eql(true)
        end
      end  

      context "'0'" do
        before(:each) do
          game.array[0] = '0'
          game.array[1] = '0'
          game.array[2] = '0'
        end

        it "three '0' in a row" do
          game.three_in_row?(0,1,2).should be true
        end

        it "system_winner is false" do
          game.three_in_row?(0,1,2)
          game.system_winner.should eql(false)
        end
      end  

      context "different" do
        before(:each) do
          game.array[0] = 'X'
          game.array[1] = '0'
          game.array[2] = '0'
        end

        it "different values in a row" do
          game.three_in_row?(0,1,2).should be false
        end

        it "system_winner is false too" do
          game.three_in_row?(0,1,2)
          game.system_winner.should eql(false)
        end
      end  
    end

    context "#win_game?" do
      it "somebody won" do
        game.stub(:three_in_row?).with(0,1,2).and_return(true)
        game.win_game?.should be true
      end

      it "system won" do
        game.array = ['X','X','X', 4, 5, 6, 7, 8, 9]
        game.should_receive(:puts).and_return("SYSTEM WON")
        game.win_game?
      end

      it "user won" do
        game.array = ['0','0','0', 4, 5, 6, 7, 8, 9]
        game.should_receive(:puts).and_return("USER WON!Congratulations!")
        game.win_game?
      end

      it "no winning combinations" do
        game.stub(:three_in_row?).and_return(false)
        game.win_game?.should be false
      end
    end

    context "#draw?" do
      it "it's draw" do
        game.array = ['0','X','0','0','X','X','X','0','X']
        game.draw?.should be true
      end

      it "not draw" do
        game.array = ['0','X','0',4,'X','X','X','0',9]
        game.draw?.should be false
      end
    end

    context "#table" do
      it "should receive puts 5 times" do
        game.should_receive(:puts).exactly(5).times
        game.table
      end
    end
  end
end
