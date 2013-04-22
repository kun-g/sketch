def theNumber()
  target = rand(100)
  puts("Input a number(0-100):")

  guess = -1
  until guess == target
    input = gets()
    guess = input.to_i()
    if guess < target
      puts("Your guess is smaller than the number")
    else 
      if guess > target
        puts("Your guess is bigger than the number")
      end
    end
  end

  puts("You win")
end

theNumber()
