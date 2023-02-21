function lpad (s, l, c)
  s = tostring(s)
  local res = string.rep(c or ' ', l - #s) .. s

  return res, res ~= s
end

