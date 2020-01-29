local L = ProbablyEngine.locale.get

ProbablyEngine.rotation.list_custom = (function()
  local classId = select(3, UnitClass("player"))
  local mySpecId = ProbablyEngine.module.player.specID


  --info = { }
  --info.isTitle = false
  --info.notCheckable = true
  --info.text = '|cff2c9800Rotation Manager|r'
  --info.func = function()
  --  ProbablyEngine.interface.manager()
  --end
  --UIDropDownMenu_AddButton(info)


  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = L('rtn_default')
  UIDropDownMenu_AddButton(info)

  for specId,_ in pairs(ProbablyEngine.rotation.rotations) do
    if specId == mySpecId then
      info = { }
      info.text = ProbablyEngine.rotation.specId[specId] or ProbablyEngine.module.player.specName
      info.value = info.text
      info.checked = (ProbablyEngine.rotation.currentStringComp == info.text or ProbablyEngine.rotation.currentStringComp == "")
      info.func = function()
        local text = ProbablyEngine.rotation.specId[specId] or ProbablyEngine.module.player.specName
        ProbablyEngine.rotation.currentStringComp = text
        ProbablyEngine.rotation.activeRotation = ProbablyEngine.rotation.rotations[specId]
        if ProbablyEngine.rotation.oocrotations[ProbablyEngine.module.player.specID] then
          ProbablyEngine.rotation.activeOOCRotation = ProbablyEngine.rotation.oocrotations[ProbablyEngine.module.player.specID]
        else
          ProbablyEngine.rotation.activeOOCRotation = false
        end
        ProbablyEngine.buttons.resetButtons()
        if ProbablyEngine.rotation.buttons[specId] then
          ProbablyEngine.rotation.add_buttons()
        end
        ProbablyEngine.print(L('rtn_switch') .. text)
        ProbablyEngine.config.write('lastRotation_' .. mySpecId, '')
      end
      UIDropDownMenu_AddButton(info)
    end
  end

  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = L('rtn_custom')
  UIDropDownMenu_AddButton(info)

  if ProbablyEngine.rotation.custom[mySpecId] then
    for _,rotation in pairs(ProbablyEngine.rotation.custom[mySpecId]) do
      info = { }
      info.text = rotation.desc
      info.value = info.text
      info.checked = (ProbablyEngine.rotation.currentStringComp == info.text)
      info.func = function()
        local text = rotation.desc
        ProbablyEngine.rotation.currentStringComp = text
        ProbablyEngine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          ProbablyEngine.rotation.activeOOCRotation = rotation.oocrotation
        else
          ProbablyEngine.rotation.activeOOCRotation = false
        end
        ProbablyEngine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        ProbablyEngine.print(L('rtn_switch') .. text)
        ProbablyEngine.config.write('lastRotation_' .. mySpecId, ProbablyEngine.rotation.currentStringComp)
      end
      UIDropDownMenu_AddButton(info)
    end
  else
    info = { }
    info.isTitle = false
    info.notCheckable = true
    info.text = L('rtn_nocustom')
    UIDropDownMenu_AddButton(info)
  end



end)

ProbablyEngine.rotation.loadLastRotation = function ()
  local specID = ProbablyEngine.module.player.specID

  local lastRotation = ProbablyEngine.config.read('lastRotation_' .. specID, '')
  if ProbablyEngine.rotation.custom[specID] and lastRotation ~= '' then
    for _, rotation in pairs(ProbablyEngine.rotation.custom[specID]) do
      if rotation.desc == lastRotation then
        local text = rotation.desc
        ProbablyEngine.rotation.currentStringComp = text
        ProbablyEngine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          ProbablyEngine.rotation.activeOOCRotation = rotation.oocrotation
        else
          ProbablyEngine.rotation.activeOOCRotation = false
        end
        ProbablyEngine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        ProbablyEngine.print(L('rtn_switch') .. text)
        break
      end
    end
  end
end
