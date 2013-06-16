require "tic_tac_toe/version"

module TicTacToe
  class Game
    attr_accessor :coin, :word, :array, :cell, :positions, :system_winner, :first
    def start
      puts "Welcome to Tic-tac-toe!"
      sleep 1
      puts "Hmm... We should find out who will be the first..."
      sleep 1
      puts "I know!Let's flip a coin!Type 'heads' or 'tails'."
      @positions = []
      @array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    def first_move
      @coin = rand(2)
      @coin == 1 ? @coin = 'heads' : @coin = 'tails'
      loop do
        @word = gets.chomp
        @word == 'heads' || @word == 'tails' ? break : p("I said, 'heads' or 'tails'!")
      end
      if @word != @coin 
        puts "Ha-ha!You lost! I'm starting."
        system_moves 
        @first = "system_moves" 
      else 
        puts "You won!Please,start."
        user_moves 
        @first = "user_moves" 
      end
    end

    def system_moves
      puts "My turn"
      if @positions.empty?
        index = rand(9)
        @array[index] = "X" 
      elsif
        smart_system(0,1,2) ||
        smart_system(3,4,5) ||
        smart_system(6,7,8) ||
        smart_system(0,3,6) ||
        smart_system(1,4,7) ||
        smart_system(2,5,8) ||
        smart_system(0,4,8) ||
        smart_system(2,4,6)
      else
        free_cells = (0...9).to_a - @positions
        index = free_cells[rand(free_cells.size)] 
        @array[index] = "X" 
      end
      @positions.push(index)
    end

    def smart_system(*indexes)
      if two_in_row?(indexes[0],indexes[1]) && (1..9).include?(@array[indexes[2]])
          @array[indexes[2]] = "X"
          return true
      elsif two_in_row?(indexes[0],indexes[2]) && (1..9).include?(@array[indexes[1]])
          @array[indexes[1]] = "X"
          return true
      elsif two_in_row?(indexes[1],indexes[2]) && (1..9).include?(@array[indexes[0]])
          @array[indexes[0]] = "X" 
          return true
      end 
      return false
    end

    def two_in_row?(*indexes)
       (@array[indexes[0]] == "X" && @array[indexes[1]] == "X") ||
       (@array[indexes[0]] == "0" && @array[indexes[1]] == "0")
    end

    def user_moves
      print "Enter the number of cell\n"
      loop do
        @cell = gets.chomp.to_i
        (1..9).include?(@cell) ? break : puts("Error!Number should be in 1..9")
      end
      @array[@cell-1] = "0" 
      @positions.push(@cell-1)
    end

    def win_game?
      if (three_in_row?(0,1,2) ||
          three_in_row?(3,4,5) ||
          three_in_row?(6,7,8) ||
          three_in_row?(0,3,6) ||
          three_in_row?(1,4,7) ||
          three_in_row?(2,5,8) ||
          three_in_row?(0,4,8) ||
          three_in_row?(2,4,6)) 
          @system_winner == true ? puts("SYSTEM WON") : puts("USER WON!Congratulations!")
        true
      else
        false
      end
    end

    def draw?
      result = @array.map {|item| !(1..9).include?(item) ? true : false}
      if result.include?(false) 
        false 
      else
        puts "Draw!"
        true 
      end
    end

    def three_in_row?(*indexes)
      if  (@array[indexes[0]] == "X" && @array[indexes[1]] == "X" && @array[indexes[2]] == "X")
        @system_winner = true
      else 
        @system_winner = false
      end
      (@array[indexes[0]] == "X" && @array[indexes[1]] == "X" && @array[indexes[2]] == "X") ||
      (@array[indexes[0]] == "0" && @array[indexes[1]] == "0" && @array[indexes[2]] == "0")

    end

    def table
      puts "   #{@array[0]} | #{@array[1]} | #{@array[2]}"
      puts "  ___|___|___"
      puts "   #{@array[3]} | #{@array[4]} | #{@array[5]}"
      puts "  ___|___|___"
      puts "   #{@array[6]} | #{@array[7]} | #{@array[8]}"
    end

    def run_game
      start 
      first_move
      table
      loop do
        if @first == "system_moves"
          user_moves
          table
          break if win_game? || draw?
          system_moves
          table
          break if win_game? || draw?
        else 
          system_moves
          table
          break if win_game? || draw?
          user_moves
          table
          break if win_game? || draw?
        end
      end
    end
  end
end
