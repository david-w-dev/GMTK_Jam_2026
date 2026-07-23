## milestone 0

- white room
- player that can move around, jump and rotate
	- melee damage
	- ranged damage
- an enemy
	- red capsule
	- can be destroyed on hit

scenes:
	- main
	- level (dw)
		- fixed walls
	- player (js)
		- sword
			- cube-like thing to show range
		- gun
	- base enemy (dw)

## ideas

- player:
	- health
- lunge with long sword press
- laser on gun fire
	- show the actual collision ray
- acceleration up to full player speed
- gun visible at all times
- holding fire brings up iron sights and reduces movement speed
- ui:
	- watch-like thing on the gun
	- ammo count + health
	- enemy count around the area, similar to timer panels?
- walls:
	- conway game of life
	- each cell is a wall
	- can be half or full height
	- reduce changes of full height walls at the boundaries
	- check no rooms to get stuck in
	- walls from the ground at the start
- panels:
	- panel count can vary
	- panel dimming interval can vary
	- different colours
- enemies:
	- have a sword
	- come towards you when within a certain radius
	- pool of enemies determined at round start
	- limited number present at once (7 or 8)
	- spawn in quickly at the round start
	- when one dies, a new one spawns down from a beam (if there are enemies left)

## milestone 1

- david:
	- [] player feel (head bob etc)
	- [x] create panel scene (+ enemy counter)
		- [x] dim() # e.g. white to red
		- [x] off() # e.g. white to off
	- [] make round area
	- [] place some more walls
	
- joe:
	- pool of enemies spawned at the start of round
	- win condition when they are all dead
	- enemy can kill you
	- fail condition if you die or run out of time
	- placement of panels in circle
	- game timer
	- debug ui: timer and enemy count

## milestone 2

- joe:
	- wall layout generation
	- @tool usage for panel placement
	- have panels turned off according to timer
