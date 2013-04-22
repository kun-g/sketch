def palindrome?(string)
  if string == nil
    return true
  end
  org = string.downcase().gsub(/[^a-z]/, "")
  rev = org.reverse()
  return org == rev
end

def count_words(string)
  if string == nil
    return nil
  end
  words =  string.downcase().scan(/\b([a-z]+)\b/)
  count = {}
  words.each do |elt|
    if count[elt] == nil
      count[elt] = 1
    else
      count[elt] = count[elt] + 1
    end
  end
  return count
end
#puts palindrome?("abcba")
=begin 
puts palindrome?("abcb")
puts palindrome?(nil)
count_words("a a a a a a")
=end
#count_words("A man, a plan, a canal -- Panama")

class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end
def rps_game_winner(game)
  raise WrongNumberOfPlayersError unless game.length == 2
end
