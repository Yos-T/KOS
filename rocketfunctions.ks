@lazyglobal off

// Multi engine Isp
// Isp = sum(Ti) / sum(Ti/Ispi)
// where 
// Ti and Ispi are the thrust and Isp of each individual engine
function enginesIsp
{
    parameter engines is list().
    local sumT is 0.
    local sumT_Isp is 0.
    for engine in engines
    {
        sumT = sumT + engine:possiblethrust.
        sumT_Isp = sumT_Isp + ( engine:possiblethrust / engine:visp ).
    }

    return sumT/sumT_Isp.
}

// Exhaust Velocity:
// Ve = Isp * g0
// Where:
// Ve : Exhaust Velocity in meters/second
// Isp: The specific impulse in dimension of time
// g0 : Standard gravity
function exhaustVelocity
{
    parameter Isp
    return Isp * constant:g0.
}

// Burn time:
// Dt = (m0 * Ve / Ft) * (1 - e^(-Dv/Ve))
// Where:
// Dt: Length of burn in seconds
// m0: Total mass of the rocket at the beginning of the burn
// Ve: Exhaust Velocity in meters/second 
// Ft : Thrust of the rocket in Newtons.
// Dv: Delta-V of burn in meters/second.
function burnTime
{
    parameter Dv.
    parameter vessel.
    parameter stages.

    local Dt is 0.

    until( Dv = 0 )
    {
        
    }
}

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


