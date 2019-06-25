// runpath("0:/test").
//@lazyglobal off

clearscreen.
local pitch_alt is 2000.
local pitch_angle is 45.
local t_apo is 80000.


//local target_name is "Jane's Debris".
//local target_vessel is vessel(target_name).
//set target to target_vessel.

// TODO: wait for launch window....

// launch
//ship:sas off.
//local dir is up + R(0,0,180).
local dir is r(up:pitch,up:yaw,facing:roll).
//lock steering to lookdirup(heading(90,90):vector, ship:facing:topvector).
//lock steering to r(up:pitch,up:yaw,facing:roll).
print "up: " + up.
lock steering to dir.
lock throttle to 1.
stage.

when (stage:ready and availablethrust = 0 )
then
{
	stage.
	return true.
}

// TODO: vertical climb
print "vertical climb".
//SHIP:AIRSPEED
SET PID TO PIDLOOP().
SET PID:MAXOUTPUT TO 1.
SET PID:MINOUTPUT TO 0.
SET PID:SETPOINT to 540.
//lock PID:SETPOINT to 540.//ship:DYNAMICPRESSURE.
//lock throttle to pid:update(TIME:SECONDS, SHIP:AIRSPEED).
wait UNTIL (ALTITUDE > pitch_alt).

// TODO: pitch over
print "up: " + up.
print "prograde: " + prograde.
print "srfprograde: " + srfprograde.
print "lock: " + (dir - R(0,pitch_angle,0)).
set dir to dir - R(0,pitch_angle,0).
//UNTIL srfprograde:yaw < up:yaw-pitch_angle
UNTIL prograde:yaw <= up:yaw-pitch_angle
{
	//SET PID:SETPOINT to 540/ship:DYNAMICPRESSURE.
	print "py: " + prograde:yaw at (0,10).
	print "spy: " + srfprograde:yaw at (0,11).
	print "uy: " + up:yaw at (0,12).
	wait 0.
}


print "pitch over done".
print "up: " + up.
print "prograde: " + prograde.

//lock steering to prograde.
unlock steering.

// TODO: raise apo
wait until obt:apoapsis > t_apo.
lock throttle to 0.

// TODO: circularize
KUNIVERSE:TIMEWARP:WARPTO( time:seconds + ETA:APOAPSIS - 30 ).
wait until ETA:APOAPSIS < 30.

SET circPID TO PIDLOOP().
SET circPID:MAXOUTPUT TO 1.
SET circPID:MINOUTPUT TO 0.
//SET circPID:SETPOINT to obt:period+15.
SET circPID:SETPOINT to 30.


lock steering to prograde.
lock throttle to circPID:update(time:second, ETA:APOAPSIS).
wait until obt:apoapsis - obt:periapsis < 100.
lock throttle to 0.

unlock throttle.
unlock steering.
//WAIT UNTIL false.
