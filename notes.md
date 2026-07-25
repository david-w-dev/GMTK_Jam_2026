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
		- [] Head bob
		- [] Jump/Landing kick
		- [] Weapon kick
		- [] Running tilt
		- [] Screen Shakes
		- [] Damage Camera kicks

	- [x] create panel scene (+ enemy counter)
		- [x] dim() # e.g. white to red
		- [x] off() # e.g. white to off
	- [] make round area
	- [] place some more walls

- joe:
	- [X] pool of enemies spawned at the start of round
	- [X] win condition when they are all dead
	- [X] enemy can kill you
	- [X] fail condition if you die or run out of time
	- [X] placement of panels in circle
	- [X] game timer
	- [X] debug ui: timer and enemy count
	- [X] @tool usage for panel placement
	- [X] have panels turned off according to timer

## milestone 2

- joe:
	- [ ] wall layout generation
		- wall circle, 50/50 chance of a wall
	- [ ] enemy health
	- [ ] make panels meet

- david:
	- [ ] player ammo count
	- [ ] enemy feedback on attack
	- [ ] enemy attack cooldown
	- [ ] player health
	- [ ] gun refinements

## milestone 3

- david:
	- [ ] create circular border scene

- joe:
	- [ ] enemy navigation to avoid the walls
	- [ ] load textures for wall generation parameters

## ideas

- radar-like minimap showing enemies
- gaining ammo according to panels left on at the end of the round
