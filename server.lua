local Config = rawget(_G, 'Config') or require 'config'

-- Register a lightweight ox_inventory shop for proper UI
CreateThread(function()
  local x, y, z = Config.coords.x, Config.coords.y, Config.coords.z
  local shop = {
    name = 'Lockpick Vendor',
    inventory = {
      { name = 'lockpick', price = Config.lockpickPrice, count = 100 },
      { name = 'advancedlockpick', price = Config.advancedLockpickPrice, count = 100 },
    },
    -- Support either ox_target-based targets or simple location
    locations = {
      { coords = vec3(x, y, z), distance = 5 },
    },
    targets = {
      [1] = { loc = vec3(x, y, z), distance = 2.5 },
    }
  }
  exports.ox_inventory:RegisterShop('lockpick_vendor', shop)
end)

local function tryBuyAmount(source, item, amount)
  amount = tonumber(amount) or 1
  if amount < 1 then return end

  local Player = exports.qbx_core:GetPlayer(source)
  if not Player then return end

  local unitPrice = item == 'advancedlockpick' and Config.advancedLockpickPrice or Config.lockpickPrice
  local total = unitPrice * amount

  -- Prefer cash then bank
  local function removeMoney(amount)
    if amount <= 0 then return true end
    if Player.Functions.RemoveMoney('cash', amount, 'lockpick-purchase') then return true end
    if Player.Functions.RemoveMoney('bank', amount, 'lockpick-purchase') then return true end
    return false
  end

  if not removeMoney(total) then
    exports.qbx_core:Notify(source, 'Not enough money', 'error')
    return
  end

  if not Player.Functions.AddItem(item, amount) then
    -- refund if inventory full
    Player.Functions.AddMoney('cash', total, 'lockpick-purchase-refund')
    exports.qbx_core:Notify(source, 'Inventory full', 'error')
    return
  end

  exports.qbx_core:Notify(source, ('Purchased %dx %s for $%d'):format(amount, item, total), 'success')
end

RegisterNetEvent('qbx_lockpick_vendor:buyAmount', function(item, amount)
  local src = source
  if item ~= 'lockpick' and item ~= 'advancedlockpick' then return end
  tryBuyAmount(src, item, amount)
end)

