local cfg = rawget(_G, 'Config') or {
  coords = { x = 168.67, y = -1811.16, z = 28.78, w = 229.56 },
  pedModel = `s_m_y_dealer_01`,
  lockpickPrice = 25,
  advancedLockpickPrice = 100,
  blip = { enabled = true, label = 'Lockpick Vendor', sprite = 52, color = 5, scale = 0.8 },
}

local pedModel = cfg.pedModel
local pedCoords = vec4(cfg.coords.x, cfg.coords.y, cfg.coords.z, cfg.coords.w)

local function spawnVendor()
  lib.requestModel(pedModel, 5000)
  local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedCoords.w, false, true)
  SetModelAsNoLongerNeeded(pedModel)
  SetEntityAsMissionEntity(ped, true, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true)
  TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_AA_COFFEE', 0, true)

  -- Create map blip (optional)
  local blipCfg = cfg.blip or {}
  if blipCfg.enabled ~= false then
    local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    SetBlipSprite(blip, blipCfg.sprite or 52)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, blipCfg.scale or 0.8)
    SetBlipColour(blip, blipCfg.color or 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipCfg.label or 'Lockpick Vendor')
    EndTextCommandSetBlipName(blip)
  end

  exports.ox_target:addLocalEntity(ped, {
    {
      name = 'qbx_lockpick_vendor_open',
      label = 'Browse Lockpicks (Shop UI)',
      icon = 'fas fa-store',
      distance = 2.0,
      onSelect = function()
        exports.ox_inventory:openInventory('shop', { type = 'lockpick_vendor', id = 1 })
      end
    },
    {
      name = 'qbx_lockpick_vendor_quick',
      label = 'Quick Buy (Select Amount)',
      icon = 'fas fa-cart-plus',
      distance = 2.0,
      onSelect = function()
        lib.registerContext({
          id = 'qbx_lockpick_vendor_ctx',
          title = 'Lockpick Vendor',
          options = {
            {
              title = ('Lockpick ($%d each)'):format(cfg.lockpickPrice),
              icon = 'key',
              onSelect = function()
                local input = lib.inputDialog('Buy Lockpicks', {
                  { type = 'number', label = 'Quantity', default = 1, min = 1, max = 50 }
                })
                if input and input[1] then
                  local qty = math.floor(tonumber(input[1]) or 1)
                  if qty > 0 then
                    TriggerServerEvent('qbx_lockpick_vendor:buyAmount', 'lockpick', qty)
                  end
                end
              end
            },
            {
              title = ('Advanced Lockpick ($%d each)'):format(cfg.advancedLockpickPrice),
              icon = 'tools',
              onSelect = function()
                local input = lib.inputDialog('Buy Advanced Lockpicks', {
                  { type = 'number', label = 'Quantity', default = 1, min = 1, max = 50 }
                })
                if input and input[1] then
                  local qty = math.floor(tonumber(input[1]) or 1)
                  if qty > 0 then
                    TriggerServerEvent('qbx_lockpick_vendor:buyAmount', 'advancedlockpick', qty)
                  end
                end
              end
            }
          }
        })
        lib.showContext('qbx_lockpick_vendor_ctx')
      end
    }
  })
end

CreateThread(function()
  spawnVendor()
end)

