##  Eratosthenes' prime number sieve
function primesieve(n::Int64)
    if n <= 1
        return Integer[]
    end

    p = [i for i in 1:2:n]
    q = length(p)
    p[1] = 2
    if n >= 9
        for k in 3:2:isqrt(n)
            if p[(k+1)÷2] != 0
                p[(k*k+1).÷2:k:q] .= 0
            end
        end
    end

    return p[p .> 0]
end


##  Find all prime numbers in  a given interval
function primes2(n::Int64, m::Int64)
    if n > m
        error("Argument 'm' must be bigger than 'n'.")
    end
    if m <= 1000
        P = primesieve(m)
        return P[P .>= n]
    end

    myPrimes = primesieve(isqrt(m))
    N = [n:m]
    l = length(N)  # m-n+1
    A = zeros(Int8, l)
    if n == 1
        A[1] = -1
    end

    for p in myPrimes
        r = n % p
        if r == 0
            i = 1
        else
            i = p - r + 1
        end
        if i <= l && N[i] == p
            i = i + p
        end
        while i <= l
            A[i] = 1
            i = i + p
        end
    end
    return N[A .== 0]
end


##  Return unique prime factors of n sorted
function primefactors(n::Int64)
    if n <= 0
        error("Argument 'n' to be factored must be a positive integer.")
    end

    f = Primes.factor(n)
    return sort(collect(keys(f)))
end


##  Find prime number following n
function nextprime2(n::Int64)
    if n <= 1; return 2; end
    if n == 2; return 3; end
    if iseven(n)
        n += 1
    else
        n += 2
    end
    if isprime(n); return(n); end

    if mod(n, 3) == 1
        a = 4; b = 2
    elseif mod(n, 3) == 2
        a = 2; b = 4
    else
        n += 2
        a = 2; b = 4
    end

    p = n
    while !isprime(p)
        p += a
        if isprime(p); break; end
        p += b
    end

    return p
end


## Find prime number preceeding n
function prevprime2(n::Int64)
    if n <= 2
        return Array(typeof(n), 0)
    elseif n <= 3
        return 2
    end

    if iseven(n)
        n -= 1
    else
        n -= 2
    end
    if isprime(n); return n; end

    if mod(n, 3) == 1
        a = 2; b = 4
    elseif mod(n, 3) == 2
        a = 4; b = 2
    else
        n -= 2
        a = 2; b = 4
    end

    p = n
    while !isprime(p)
        p -= a
        if isprime(p); break; end
        p -= b
    end

    return p
end


##  Find all twin primes
function twinprimes(n::Int64, m::Int64)
    P = primes2(n, m)
    inds = findall(diff(P) .== 2)

    return hcat(P[inds], P[inds.+1])
end


##  Coprimality
function coprime(n::Int64, m::Int64)
    if n == 0 && m == 0
        return false
    end

    if gcd(n, m) > 1
        false
    else
        true
    end
end


##  Solve linear modulo equations
function linmod(a::Int64, b::Int64, m::Int64)
    m > 1 || error("Argument 'm' must be an integer greater 1")
    T = typeof(m)
    g, e, f = gcdx(a, m)

    x = T[]
    if mod(b, g) == 0
        x0 = mod(e * div(b, g), m)
        for i = 0:(g-1)
            x = [x, mod(x0 + i * div(m, g) , m)]
        end
    end

    return x
end


##  Order of the element n (in the ring) modulo m
function ordermod(n::Int64, m::Int64)
    if n <= 0 || m <= 0
        error("Arguments 'n' and 'm' must be positive integers.")
    end
    if m == 1 || gcd(n, m) > 1; return 0; end
    if n == 1; return 1; end

    r = mod(n, m)
    if r == 0; return 0; end

    k = 1
    while r != 1
        r = mod(n*r, m)
        k += 1
    end

    return k
end


##  Find a primitive root modulo m
function primroot(m::Int64)
    if !isprime(m)
        error("Argument 'm' must be a prime number")
    end
    if m == 2; return 1; end

    P = primefactors(m-1)
    for r = 2:(m-1)
        not_found = true
        for p in P
            if powermod(r, div(m-1, p), m) == 1
                not_found = false
            end
        end
        if not_found
            return r
        end
    end

    return 0
end


##  Euler's Phi (or: totient) function
function eulerphi(n::Int64)
    if n <= 0
        error("Argument 'n' must be a (positive) natural number.")
    end

    m = n
    for p in primefactors(n)    # must be unique
        m = m - div(m, p)       # m = m * (1 - 1/p)
    end

    return Integer(round(m))
end
