
TODO:

- [] Highlight the current workout "selected". I want to make it so that pressing left and right doesn't automatically scroll the entire list of workouts. Instead I want to have the highlighted workout move until it hits the edge and then we scroll. This may be accomplished by changing the condition on which getBoxIndices is called. I could keep a highlightIndex variable that is set to one of the indices generated. When highlight index pushes past the highest index in the list, then we call getBoxIndices with the new range... And we highlight the index pointed to by highlightIndex in some way.
- [] Make it so that pressing a button will go to the end of the list of workouts and another will go to the beginning of the list. Maybe a button that goes to the middle? Maybe have a select mode that lets you push a button followed by a number to jump to the selected workout?
- [] Add some colors for background, box lines, box, and font.
- [] Make it so that the distance between boxes and the position of the text within the boxes is relative to the computed width of the box. I'm thinking we can make the box 10% bigger than the widest piece of text. Then we can shift all the text %5 of that value to the right. Then we can make all the box coordiates 1.05 times the width of the box? Right now I just have hard coded values and I'm not sure how long that will hold up.
- [] Add a date field to the json and display that as well? Maybe I don't care about this.
- [] Add some screen scaling so the image grows with a mouse drag and stuff. I think there's a single love2d function for this but I don't remember.

Done:
- [x] 20251216: Make it so that the title forces the width of the box to expand to fit. Right now, only the width of the contents of the workout determine the width of the box. We need to change that. Or, maybe I can subdivide the bottom curve part to have the index instead? Sort of how the name of the workout is displayed at the top. -- Solved this by just changing the inputs to the drawWorkoutBox function. Created the name by concatenating the current index with the total number of workouts with the name. Easy.
- [x] 20251216: Make it so screenshots go in their own screenshot folder.
- [BugFix] 20251215: Fixed a bug where if there were fewer than 4 workouts it would display repeated workouts until four were shown. Now properly displays the amount available if less than four.
- [x] 20251207: Make it so that the index of the element shows up the the top field of the workout box. That way I can tell where I am in the file. Maybe another that shows the total number? Maybe we can show the displayIndex/numWorkouts in a corner somwhere?
- [x] 20251207: Make types case insensitive.
- [x] 20251205: Fix up the Linebreak json field so that it actually draws a line that separates workouts across a workout box.
- [x] 20251203: Make it so that the game screen dynamically shrinks to fit the number of currently displayed workouts. That way, when a screenshot is taken there isn't a bunch of dead screen space in the shot.
- [x] 20251203: Make it so that screenshots dated the same are now numbered in the order they are taken. I guess I can add a time stamp, but I don't like that. (Made it so that the save format is YYYYMMDD_HHMMSS)
- [x] 20251203: Make 'q' keypress quit the program.
- [x] 20251201: Make it so that I can type a number key and then display that many workouts at once. Max of 7, caps out at the max workouts in the file. Make it circular from the curent displayIndex. So if I have 7 and set the index to 6, and we want to display 4 we should display these:
    [1] [2] [3] [4] [5] [6] [7]
     ^   ^               ^   ^
     We might need to make a circular display buffer class or something. It can get a current display index and a width and return the indices of the workouts to display as an array.
- [x] 20251130: Make it so that the screenshot button saves as workout_YYYYMMDD.png