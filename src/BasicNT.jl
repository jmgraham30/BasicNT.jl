module BasicNT

using Primes

export primesieve, primes2,
         nextprime2, prevprime2,
         primefactors, twinprimes,
         coprime, linmod,
         ordermod, primroot,
         eulerphi

  include("primes.jl")

end # module
