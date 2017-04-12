This is a simple command line warehouse management tool. The user can record the storage and removal of crates of variable size on a rack of shelves.

It accepts the following 7 commands:

- help - Shows the help message
- init W H - (Re)Initialises the application with a W x H rack of shelves, with all spaces
- empty.
- store X Y W H P - Stores a crate of product code P and of size W x H at position X,Y.
- locate P - Show a list of positions where product code P can be found.
- remove X Y - Remove the crate at positon X,Y.
- view - Show a representation of the current state of the shelves, marking each position as filled or empty. Position 0,0 should be the lower left position and 0,H should be the top left
- exit - Exits the application.

Arguments W, H, X and Y will always be integers, and P will always be a single character. You should not worry about validating the format of the input.

The user should also be shown an error message when:

- Trying to store a crate at a position which doesn't exist.
- Trying to store a crate which doesn't fit.
- Trying to remove a crate which doesn't exist.
