local Funcs = {}

function Funcs.lerp(a, b, t)
  return a + (t * (b - a))
end

return Funcs
