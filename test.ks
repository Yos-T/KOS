// runpath("0:/test").

// Exhaust Velocity:
// Ve = Isp * g0
// Where:
// Ve : Exhaust Velocity in meters/second
// Isp: The specific impulse in dimension of time
// g0 : Standard gravity

// Burn time:
// Dt = (m0 * Ve / Ft) * (1 - e^(-Dv/Ve))
// Where:
// Dt: Length of burn in seconds
// m0: Total mass of the rocket at the beginning of the burn
// Ve: Exhaust Velocity in meters/second 
// Ft : Thrust of the rocket in Newtons.
// Dv: Delta-V of burn in meters/second.

// Tsiolkovsky rocket equation:
// Dv = Ve * ln( m0/ mf )
// Where:
// Dv: Delta-V of burn in meters/second.
// Ve: Exhaust Velocity in meters/second
// ln: Natural log
// m0: Total mass of the rocket (wet mass)
// mf: final total mass without propellant (dry mass)

// Fuel consumption:
// Isp = Ft/m
// Where:
// Isp: specific impulse in meters per second
// Ft : thrust in newtons
// m  : fuel consumption in kg/s

// Multi engine Isp
// Isp = sum(Ti) / sum(Ti/Ispi)
// where 
// Ti and Ispi are the thrust and Isp of each individual engine

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
