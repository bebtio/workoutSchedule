
TODO:

- [] Make it so screenshots go in their own screenshot folder.
- [] Make 'q' keypress quit the program.
- [] Make it so that screenshots dated the same are now numbered in the order they are taken. I guess I can add a time stamp, but I don't like that.
- [] Make it so that the game screen dynamically shrinks to fit the number of currently displayed workouts. That way, when a screenshot is taken there isn't a bunch of dead screen space in the shot.
- [] Fix up the Linebreak json field so that it actually draws a line that separates workouts across a workout box.
- [] Add some colors for background, box lines, box, and font.
- []

Done:
- [x] 20251201: Make it so that I can type a number key and then display that many workouts at once. Max of 7, caps out at the max workouts in the file. Make it circular from the curent displayIndex. So if I have 7 and set the index to 6, and we want to display 4 we should display these:
    [1] [2] [3] [4] [5] [6] [7]
     ^   ^               ^   ^
     We might need to make a circular display buffer class or something. It can get a current display index and a width and return the indices of the workouts to display as an array.
- [x] 20251130: Make it so that the screenshot button saves as workout_YYYYMMDD.png