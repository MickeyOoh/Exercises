defmodule Queens.Server do 
  use GenServer

  def start_link(queens) do 
    #IO.puts "start_link is called #{current_number}." 
    GenServer.start_link(__MODULE__, queens, name: __MODULE__)
  end
  def init(board) do
    {:ok, board}
  end
  def getdt do 
    GenServer.call(__MODULE__, :get)
  end
  def update(setdt) do 
    GenServer.call(__MODULE__, {:update, setdt})
  end

  #####
  # GenSerer implementation

  def handle_call(:get, _from, board) do
    { :reply, board, board}
  end
  def handle_call({:update, setdt}, _from, _board) do
    { :reply, setdt, setdt}
  end
  ## add cast
  def handle_cast({:update, setdt}, _board) do 
    { :noreply, setdt}
  end
  def format_status(_reason, [ _pdict, state ]) do 
    [data: 
     [{'State',"My current state is '#{inspect state}', and I'm happy"}]
    ]
  end
end
