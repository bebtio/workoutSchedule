
TODO:

- [] Make it so that the index of the element shows up the the top field of the workout box. That way I can tell where I am in the file.
- [] Add a date field to the json and display that as well.
- [] Make it so screenshots go in their own screenshot folder.
- [] Add some colors for background, box lines, box, and font.
- [] Make it so that the distance between boxes and the position of the text within the boxes is relative to the computed width of the box. I'm thinking we can make the box 10% bigger than the widest piece of text. Then we can shift all the text %5 of that value to the right. Then we can make all the box coordiates 1.05 times the width of the box? Right now I just have hard coded values and I'm not sure how long that will hold up.

Done:
- [x] 20251205: Fix up the Linebreak json field so that it actually draws a line that separates workouts across a workout box.
- [x] 20251203: Make it so that the game screen dynamically shrinks to fit the number of currently displayed workouts. That way, when a screenshot is taken there isn't a bunch of dead screen space in the shot.
- [x] 20251203: Make it so that screenshots dated the same are now numbered in the order they are taken. I guess I can add a time stamp, but I don't like that. (Made it so that the save format is YYYYMMDD_HHMMSS)
- [x] 20251203: Make 'q' keypress quit the program.
- [x] 20251201: Make it so that I can type a number key and then display that many workouts at once. Max of 7, caps out at the max workouts in the file. Make it circular from the curent displayIndex. So if I have 7 and set the index to 6, and we want to display 4 we should display these:
    [1] [2] [3] [4] [5] [6] [7]
     ^   ^               ^   ^
     We might need to make a circular display buffer class or something. It can get a current display index and a width and return the indices of the workouts to display as an array.
- [x] 20251130: Make it so that the screenshot button saves as workout_YYYYMMDD.png