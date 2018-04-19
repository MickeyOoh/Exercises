defmodule Bob do
  @answer %{
    silent: "Fine. Be that way!",
    shout_question: "Calm down, I know what I'm doing!",
    question: "Sure.",
    shouting: "Whoa, chill out!",
    meaningless: "Whatever."} 

  def hey(input) do
    cond do
      silent?(input) -> @answer.silent
      shout_question?(input) -> @answer.shout_question
      question?(input) -> @answer.question
      shouting?(input) -> @answer.shouting
      true -> @answer.meaningless
      #true -> raise "Your implementation goes here"
    end
  end
  defp silent?(input) do 
     "" == String.trim(input) 
  end
  defp shouting?(input) do 
    input == String.upcase(input) && letters?(input)
    #  Regex.run(~r/!/, input) 
  end
  defp question?(input) do 
    Regex.run(~r/\?$/, input) 
  end
  defp shout_question?(input) do 
    shouting?(input) && question?(input) 
  end
  defp letters?(input) do 
    Regex.match?(~r/\p{L}+/, input)
  end
end
