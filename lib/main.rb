# City TicTacToe
# Plays tic-tac-toe against itself. Minimax algorithm vs random moves.
# It does NOT use alpha-beta pruning. And also, does NOT re-use the minimax generated game tree.
# So it takes a lot of time and a lot of memory.
# It also probably doesn't work since I haven't tested anything.
# Lloyd

class Player
  attr :side,:name
  
  def
    initialize(side,name)
    @side = side
    @name = name
   
    if side == "X"
      opside = "O"
    else
      opside = "X"
    end
    @opside = opside
   
    puts "Added #{@name} playing #{@side}"
  end 
 
  def randommoves(board)
    x,y=0,0
    begin 
      x,y = rand(3), rand(3)
    end until board.isempty(x,y)
    return x,y
  end
 
  def ai1(giveboard)
    puts "(Using minimax)"
    depth = 50
   
    resultArray =[0,0,0]
    resultArray = minimax(giveboard,depth,true)
    #puts "resultarray is #{resultArray}"
    x,y = resultArray[1],resultArray[2]
    #puts "AI XY #{x}  #{y}"
    return x,y
  end
 
  def minimax(giveboard,depth,maximizingplayer)
  
    #puts "Nodes at this level: #{giveboard.number_of_moves_available()}"
  
    bestArray = [0,-1,-1]
    valueArray = [0,-1,-1]
    #puts "depth is #{depth}"
  
    if depth == 0 || giveboard.number_of_moves_available() == 0 || giveboard.linecomplete() == true
      
      if giveboard.linecomplete() == false
        #this leaf is a draw
        
        bestArray = [0,giveboard.lastAddedX,giveboard.lastAddedY]
      else
        #someone won
        
        if maximizingplayer == true #(that's us)
          bestArray = [10,giveboard.lastAddedX,giveboard.lastAddedY]
        else
          bestArray = [-10,giveboard.lastAddedX,giveboard.lastAddedY]

        end
      end
      return bestArray
    end
   
    if maximizingplayer == true
      bestArray[0] = -1000000000000000
      
      for x in 0..2
        
        for y in 0..2
          
          if giveboard.isempty(x,y)
            
            childboard = Board.new()
            #p "new childboard created#{childboard.to_s}"
           
            childboard = giveboard.clone()
            #childboard.printOut()

            childboard.move(x,y,@side)
            #childboard.printOut()
            #uncomment this to see what the minimax internal nodes look like
            
            valueArray = minimax(childboard,depth - 1,false)
           
            if bestArray.first < valueArray.first
              #pick max  
              bestArray = valueArray
              #p "new bestarray #{bestArray}"
            end
           
           
          end
        end
      end
      return bestArray
     
    else
      
      bestArray[0] = 1000000000000000
      for x2 in 0..2
        for y2 in 0..2
          if giveboard.isempty(x2,y2)
           
            childboard2 = Board.new()
            childboard2 = giveboard.clone()
            #p "new else childboard created#{childboard2.to_s}"
            #childboard2.printOut()
            
            childboard2.move(x2,y2,@opside)
            #childboard2.printOut()
            #uncomment this to see what the minimax internal nodes look like

            valueArray = minimax(childboard2,depth - 1,true)
            
            if bestArray.first > valueArray.first
              #pick min  
              bestArray = valueArray
              #p "new bestarray #{bestArray}"
           
            end
           
           
          end
        end
      end
      return bestArray
     
    end
    # if relativeplayer.to_s == "maximizingplayer"
    #    bestValue = -1000000000000000
    #     for each child of node
    #         v := minimax(child, depth − 1, FALSE)
    #         bestValue := max(bestValue, v)
    #     return bestValue , bestX, bestY
    #     end
    # else    #other player (min)
    ##     bestValue := +∞
    #      for each child of node
    #         v := minimax(child, depth − 1, TRUE)
    #          bestValue := min(bestValue, v)
    #      return bestValue , bestX, bestY
    #      end
    #   end   
    #
    #return bestx, besty
  end
  
  def prologmoves()
    return prologx, prology
  end
 
end

class Board
  attr :board, :empty,:lastAddedX, :lastAddedY
  @@cross='X';
  @@noughts ='O';
  @@empty='_';
  

  def initialize()
    @board = Array.new(3){Array.new(3, @@empty)} 
    @winner = false
    @lastAddedX = -1
    @lastAddedY = -1
  end

  def clone()
    cloneboard = Board.new()

    for i in 0..2
      for j in 0..2
        cloneboard.board[i][j] = board[i][j];

      end
    end
	
    return cloneboard;
    
  end


  def isempty(x,y)
    if @board[x][y] == @@empty
      return true
    else
      return false
    end
  end

  def
    move(x,y,character)
    if board[x][y] == @@empty
      board[x][y]=character;
      @lastAddedX = x
      @lastAddedY = y
      #puts "Placing #{character} on #{x} #{y}"
    else
      p "error: That move has already been played."
    end
  
  end

  def
    iswinner()
    return linecomplete()
  end

  def
    rowcomplete()
    board.each { |i|
      if i[0]== i[1] && i[1]==i[2]
        if i[0] == @@empty
          return false
        else
          #puts "3 in a row!"
          return true
        end
      end

    }

  end

  def
    colcomplete()
    i=0
    until i == 3
      if board[0][i] == board[1][i] && board[1][i] == board[2][i]
        if board[0][i] != @@empty
          #puts "3 vertical!"
          return true
        else
          return false
        end   
      else
        return false
        
      end
      i = i+1
    end
  
  
  end

  def
    diagonalcomplete()
    if board[0][0] != @@empty
      if board[0][0] == board[1][1] && board[1][1] == board[2][2]
        #puts "Diagonal!"
        return true
      else
        return false
      end
    end
  end
  
  def otherdiag()
    if board[0][2] != @@empty
      if board[0][2] == board[1][1] && board[1][1] == board[2][0]
        #puts "Other diagonal!"
        return true
      else
        return false
      end
    end
  
  end

  def
    linecomplete()
    if rowcomplete()== true || colcomplete() == true || diagonalcomplete() == true || otherdiag() == true
      #puts "We have a line!"
      return true
    else
      return false
    end
  end

  def printOut()
    puts ""
    puts '~~~~~~~~~~~~~~~'
 
    print board[0][0..2]; puts '';
    print board[1][0..2]; puts '';
    print board[2][0..2]; puts '';
    puts '~~~~~~~~~~~~~~~'
   

    #puts "flat: #{board.flatten.select { |value| value == '_' }}"
    puts "There are #{number_of_moves_available()} moves available"
  end

  def number_of_moves_available()
    return board.flatten.count(@@empty)
  end




end

puts "Terribly bad TicTacToe"
puts "Begin!"

myCityBoard = Board.new()
myCityBoard.printOut()
p1 = Player.new('X',"Randy")
p2 = Player.new('O',"Stan")


currentplayer = p1

while myCityBoard.iswinner() == false

  puts "#{currentplayer.name}'s turn"
  

  if currentplayer == p1
    x,y = currentplayer.randommoves(myCityBoard)
  else
    x,y = currentplayer.ai1(myCityBoard)
  end
  
  
  puts "#{currentplayer.name} is placing a '#{currentplayer.side}' in square [#{x},#{y}]"

  myCityBoard.move(x,y,currentplayer.side)
  
  myCityBoard.printOut()

  if myCityBoard.iswinner() == true
    puts "================="
    puts "We have a winner!"
    puts "================="
    puts "#{currentplayer.name} Wins!"
  
  end

  if myCityBoard.number_of_moves_available() == 0
    puts "Draw!"
    exit
  end


  if currentplayer.side == p1.side
    currentplayer = p2
  else
    currentplayer = p1
  end
end


if currentplayer.side == p1.side
  currentplayer = p2
else
  currentplayer = p1
end


