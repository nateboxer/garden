# The Garden

The garden was a project I built to explore evolving plant morphology (without any selection pressure or fitness function other than human interaction.) Each plant's DNA contains drawing instructions that mutate over time. People interact with the simulation via a web site and may vote on the plants they like, thus ensuring those plants' DNA will survive to the next generation (with mutations.)

<p align="center"><img src="http://nateboxer.net/i/garden.jpg"/></p>

## Modules

**GardenClient** - The main Flash project. This shows the garden landscape and spawns the evolving plants. You can see it [here](http://nateboxer.net/garden/) (warning Flash).

**DnaBrowser** - When I eventually decided to have an art show based on the plants that had evolved, I built this tool so that I could quickly and efficiently view all the plants. I ended up reviewing about 10,000 plants and picking about 200 to work with for the show. I printed and framed about 40 of the finalists. You can see some of them [here](http://nateboxer.net/art/2009/)

**GardenCore** - Core common functionality used by the garden, the voting utilities, the viewers etc. Contains mainly drawing functions.

**GardenCore2** - The same functionality modified to support sexual reproduction and some improvements to the drawing language.

**GardenServer** - The backend of the garden project. Handles interfacing with the MySQL database and doing the DNA recombination.
