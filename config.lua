Config = {
  -- Use plain numbers so this file loads on both client and server
  coords = { x = 168.67, y = -1811.16, z = 28.78, w = 229.56 },
  pedModel = `s_m_y_dealer_01`,

  -- Prices
  lockpickPrice = 25,
  advancedLockpickPrice = 100,

  -- Map Blip
  blip = {
    enabled = true,
    label = 'Lockpick Vendor',
    sprite = 52,   -- general store icon
    color = 5,     -- yellow
    scale = 0.8,
  },
}

return Config

