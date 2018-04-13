defmodule Mark do 
  defstruct first: 0, second: 0, subtotal: 0, con_rolls: 0
end
defmodule MarkEnd do 
  defstruct first: 0, second: 0, third: 0, subtotal: 0, con_rolls: 0
end
defmodule BowlingGame do
  defstruct rolls: 0 
            frame_no: 0, # current frame 0-10 
            roll_nth: 0, # roll in a frame, 0,1
            cal_frame: = 0 
            scores: List.duplicate(nil, 9) ++ [%MarkEnd{}]
            total: 0     # total
end

defmodule Bowling do
  @spare "/"
  @strike "x"
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    game = %BowlingGame{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(_, roll) when roll < 0 or roll > 10 do 
    if roll < 0 do 
      {:error, "Negative roll is invalid"}
    else 
      {:error, "Pin count exceeds pins on the lane"}
    end
  end
  def roll(game, roll) do
    if game.frame_no == game.cal_frame do  
      mark = Enum.at(game.scores, game.cal_frame)
      if mark.con_rolls > 0 do 
        mark.con_rolls = mark_con_rolls - 1
        mark.subtotal = mark.subtotal + roll
        if mark.con_rolls <= 0 do 
          game.cal_frame = game.cal_frame + 1
        end
      else
        IO.puts "cal_frame error:#{game.cal_frame}"
      end
    end
    cond do 
      game.frame_no < (10 - 1) ->  # 9th Frame
        update_score(game.roll_count, game, roll)
      game.frame_no  == (10 - 1) ->  # the last Frame 10th
        update_score(game.roll_count, game, roll)
      _ ->
        "error"
    end
  end
  def update_score(1, game, score) do 
    frame_no = game.frame_no
    cond do 
      game.add_roll == 0 ->   # no spare/strike before this roll
        if score == 10 do  # strike
          mark = %Mark{first: @strike, second: 0, subtotal: 0}
          List.replace_at(game.scores, frame_no, mark)
          game.tmp = 10
          game.add_roll = 2
          game.total = game.score + game.total
        else
          mark = %Mark{first: score}
          List.replace_at(game.scores, frame_no, mark)
        end 
      game.add_roll == 1 ->  # Spare before this
        pre_score = Enum.at(game.scores, frame_no - 1)
        subtotal = game.tmp + score + pre_score.subtotal
        mark = %Mark{subtotal: subtotal}
        List.replace_at(game.scores, frame_no - 1, mark)
        if score == 10 do  # strike
          mark = %Mark{first: @strike, second: 0, subtotal: 0}
          List.replace_at(game.scores, frame_no, mark)
          game.tmp = 10
          game.add_roll = 2
        else
          mark = %Mark{first: score}
          List.replace_at(game.scores, frame_no, mark)
        end 
      game.add_roll == 2 -> # strike before this
          
        game.tmptotal = score
    scores = List.replace_at(game.scores, frame_no - 1, mark) 
    if game.count_roll > 0 do 
      game.count_roll = game.count_roll - 1
      prescore = Enum.at(game.scores, frame_no - 1 - 1)   
    end
    tmptotal = score
    scores = List.replace_at(game.scores, frame_no - 1, mark) 
    cond do 
      score == 10 ->
        if game.addroll > 0 do
          game.addroll
        game.addroll = 2
        game.tmptotal = 10
        %{game | frame_no: frame_no + 1, scores: scores}
      true ->
        game.tempcount = score
        %{game | roll_nth: 2, scores: scores}
    end
  end
  def update_score(:second, game, score) do 
    frame_no = game.frame_no
    old_scores = game.scores
    old_frame_values = Enum.at(old_scores, frame_no - 1)
    new_frame_values = List.replace_at(old_frame_values, 1, score)
    new_scores = List.replace_at(old_scores, frame_no - 1, new_frame_values)
    
    %{game | scores: new_scores, roll_nth: 1, frame_no: frame_no + 1}
  end 
  def update_total(game) do 
    #Enum.map(game.scores, fn [first, second] -> 
  end 
  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @ergmsg "Score cannot be taken until the end of the game"
  @spec score(any) :: integer | String.t()
  def score(game) do
    cond do 
      game.frame_no < 10 ->
        {:error, @ergmsg}
      
      true ->
        lscores = game.scores |> List.flatten
        Enum.sum(lscores)
    end
  end
  def roll_reduce(game, rolls) do 
    Enum.reduce(rolls, game, fn roll, game -> Bowling.roll(game, roll) end)
  end

end
