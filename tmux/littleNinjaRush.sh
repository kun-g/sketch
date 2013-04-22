tmux has-session -t littleNinjiaRush
if [ $? != 0 ]
then
  tmux new-session -s littleNinjiaRush -n normal -d

  tmux send-keys -t littleNinjiaRush:0.0 'cd ~/Code/' C-m
  tmux send-keys -t littleNinjiaRush:0.0 'vim littleNinjaRush.sh' C-m

  # window 1
  tmux new-window -n editor -t littleNinjiaRush
  tmux send-keys -t littleNinjiaRush 'cd ~/Code/NinjiaRush/android/LtlNinjaRush/' C-m

  # window 2
  tmux new-window -n compile -t littleNinjiaRush
  # tmux split-window -h -p 50 -t littleNinjiaRush
  # tmux split-window -v -p 50 -t littleNinjiaRush:1.0
  # tmux split-window -v -p 50 -t littleNinjiaRush:1.1
  tmux send-keys -t littleNinjiaRush:2.0 'cd ~/Code/NinjiaRush/android/LtlNinjaRush/proj.linux' C-m
  # tmux send-keys -t littleNinjiaRush:1.0 'cd ~/Code/NinjiaRush/android/LtlNinjaRush/proj.linux/bin/debug' C-m
  # tmux send-keys -t littleNinjiaRush:1.2 'cd ~/Code/NinjiaRush/android/NinjiaRush/' C-m
  # tmux send-keys -t littleNinjiaRush:1.3 'cd ~/Code/NinjiaRush/android/NinjiaRush/' C-m

  # window 3 #################
  tmux new-window -n example -t littleNinjiaRush
  tmux send-keys -t littleNinjiaRush:3.0 'cd ~/develop/cocos2dx/samples/Cpp/TestCpp/' C-m
  tmux split-window -v -p 10 -t littleNinjiaRush
  tmux send-keys -t littleNinjiaRush:3.1 'cd ~/develop/cocos2dx/samples/Cpp/TestCpp/proj.linux/bin/debug' C-m
  tmux split-window -h -p 50 -t littleNinjiaRush

  # window 4 ################
  tmux new-window -n blog -t littleNinjiaRush
  tmux send-keys -t littleNinjiaRush:4.0 'cd ~/Code/blog/_posts' C-m
  tmux split-window -v -p 10 -t littleNinjiaRush
  tmux send-keys -t littleNinjiaRush:4.1 'cd ~/Code/blog' C-m

  # window 5 ################
  # tmux new-window -n config -t littleNinjiaRush

  tmux select-window -t littleNinjiaRush:0
fi
tmux attach -t littleNinjiaRush
