' Roku BrightScript murmur hash implementation
'
' @author Dmytro Frolov
' @see https://github.com/dmytrofrolov/murmurhash-brightscript
'
' References:
' https://github.com/garycourt/murmurhash-js/blob/master/murmurhash3_gc.js
' https://en.wikipedia.org/wiki/MurmurHash


' @param {string} key - ASCII text to calculate hash
' @param {integer} seed - Positive integer
' @return {integer} - Calculated hash integer
function murmur(key, seed = &h0DF007 as Integer)
    remainder = 0
    bytes = 0
    h1 = 0
    h1b = 0
    c1 = 0
    c1b = 0
    c2 = 0
    c2b = 0
    k1 = 0
    i = 0

    remainder = len(key) AND 3
    bytes = len(key) - remainder
    h1 = seed
    c1 = &hcc9e2d51
    c2 = &h1b873593
    i = 0

    While i < bytes
        k1 = (Asc(key.mid(i, 1)) and &hff) or (Asc(key.mid(i+1, 1)) and &hff) << 8 or (Asc(key.mid(i+2, 1)) and &hff) << 16 or (Asc(key.mid(i+3, 1)) and &hff) << 24
        i += 4
        k1 = ((((k1 AND &hffff) * c1) + ((((k1 >> 16) * c1) AND &hffff) << 16))) AND &hffffffff
        k1 = (k1 << 15) OR (k1 >> 17)
        k1 = ((((k1 AND &hffff) * c2) + ((((k1 >> 16) * c2) AND &hffff) << 16))) AND &hffffffff
        h1 = xor(h1, k1)
        h1 = (h1 << 13) OR (h1 >> 19)
        h1b = ((((h1 AND &hffff) * 5) + ((((h1 >> 16) * 5) AND &hffff) << 16))) AND &hffffffff
        h1 = (((h1b AND &hffff) + &h6b64) + ((((h1b >> 16) + &he654) AND &hffff) << 16))
    End While
    k1 = 0
    
    if remainder > 0
        if remainder = 1
            k1 = xor(k1, (Asc(key.mid(i, 1)) and &hff))
        else if remainder = 2
            k1 = xor(k1, (Asc(key.mid(i+1, 1)) and &hff) << 8)
            k1 = xor(k1, (Asc(key.mid(i, 1)) and &hff))
        else if remainder = 3
            k1 = xor(k1, (Asc(key.mid(i+2, 1)) and &hff)  << 16)
            k1 = xor(k1, (Asc(key.mid(i+1, 1)) and &hff) << 8)
            k1 = xor(k1, (Asc(key.mid(i, 1)) and &hff))
        end if
        k1 = (((k1 AND &hffff) * c1) + ((((k1 >> 16) * c1) AND &hffff) << 16)) AND &hffffffff

        k1 = (k1 << 15) OR (k1 >> 17)
        k1 = (((k1 AND &hffff) * c2) + ((((k1 >> 16) * c2) AND &hffff) << 16)) AND &hffffffff

        h1 = xor(h1, k1)
    end if

    h1 = xor(h1, len(key))
    h1 = xor(h1, h1 >> 16)
    h1 = (((h1 and &hffff) * &h85ebca6b) + ((((h1 >> 16) * &h85ebca6b) AND &hffff) << 16)) AND &hffffffff
    h1 = xor(h1, h1 >> 13)
    h1 = ((((h1 AND &hffff) * &hc2b2ae35) + ((((h1 >> 16) * &hc2b2ae35) AND &hffff) << 16))) AND &hffffffff
    h1 = xor(h1, h1 >> 16)

    h2 = 0&
    for i = 0 to 31
        x = (h1 and 1& << i) >> i
        h2 = h2 or (x << i)
        x2 = (h2 and 1& << i) >> i
    end for

    return h2
end function

function xor(a, b) as integer
    return nand(nand(a, nand(a, b)), nand(b, nand(a, b)) )
end function

function nand(a, b) as integer
    return not (a and b)
end function
