
TODO:

- [] Make it so that I can type a number key and then display that many workouts at once. Max of 7, caps out at the max workouts in the file. Make it circular from the curent displayIndex. So if I have 7 and set the index to 6, and we want to display 4 we should display these:
    [1] [2] [3] [4] [5] [6] [7]
     ^   ^               ^   ^
     We might need to make a circular display buffer class or something. It can get a current display index and a width and return the indices of the workouts to display as an array.
- [] Make it so that the screenshot button saves as workout_YYYYMMDD.png
- [] 