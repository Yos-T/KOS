// runpath("0:/test").
//@lazyglobal off

clearscreen.
//local target_name is "Jane's Debris".
//local target_vessel is vessel(target_name).
//set target to target_vessel.

// TODO: wait for launch window....

// launch
//ship:sas off.
local dir is up + R(0,0,180).
//lock steering to lookdirup(heading(90,90):vector, ship:facing:topvector).
//lock steering to r(up:pitch,up:yaw,facing:roll).
print "up: " + up.
lock steering to dir.
lock throttle to 1.
stage.

// TODO: vertical climb
print "vertical climb".
//SHIP:AIRSPEED
SET PID TO PIDLOOP().
SET PID:MAXOUTPUT TO 1.
SET PID:MINOUTPUT TO 0.
SET PID:SETPOINT to 540.
//lock PID:SETPOINT to 540.//ship:DYNAMICPRESSURE.
lock throttle to pid:update(TIME:SECONDS, SHIP:AIRSPEED).
wait UNTIL (ALTITUDE > 2000).

// TODO: pitch over
print "up: " + up.
print "prograde: " + prograde.
print "srfprograde: " + srfprograde.
print "lock: " + (dir - R(0,10,0)).
set dir to dir - R(0,10,0).
UNTIL srfprograde:yaw < up:yaw-5
{
	//SET PID:SETPOINT to 540/ship:DYNAMICPRESSURE.
	print "py: " + prograde:yaw at (0,10).
	print "spy: " + srfprograde:yaw at (0,11).
	print "uy: " + up:yaw at (0,12).
	wait 10.
}


print "pitch over done".
print "up: " + up.
print "prograde: " + prograde.

//lock steering to prograde.
unlock steering.

// TODO: raise apo

// TODO: circularize

WAIT UNTIL false.
